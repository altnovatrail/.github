package main

import (
	"fmt"
	"go/ast"
	"go/importer"
	"go/parser"
	"go/token"
	"go/types"
	"os"
	"path/filepath"
	"slices"
	"strconv"
	"strings"
)

// The rules a finding names. A caller's lists say what its code and tests may take; the rules
// themselves, and what they allow of math, strings and strconv, are the same for every caller
// (R107 in spec). Each rule is named by a word, as the comments "// want <rule>" of the controls in
// testdata/ name them; a repository numbers its rules in its own documents.
var allRules = []string{
	"import",    // a package outside the lists, of code or of tests
	"cgo",       // import "C"
	"asm",       // a source file the go command would hand to another tool: .s and the like
	"linkname",  // a //go:linkname directive
	"buildtag",  // a //go:build or +build line, or a file name the go command reads as one
	"require",   // a require directive in go.mod for a module the lists do not name
	"replace",   // a replace directive in go.mod: a module as no release gave it (R77 in spec)
	"nested",    // a go.mod below the root, which the module's zip leaves out
	"math",      // a function of math whose result is not defined exactly
	"fused",     // a float * or / whose result does not go straight into float64()
	"assignop",  // *= or /= on a float
	"complex",   // a complex value
	"typeparam", // arithmetic on a type parameter that may be a float
	"maprange",  // a range over a map in code
	"unicode",   // a function of strings or strconv that reads the Unicode tables, in code
	"goroutine", // a go statement in code
}

// The functions of math whose result is defined exactly, the only ones code may call; tests may
// call those the lists name besides, test-math.
var mathFuncs = []string{
	"Abs", "Ceil", "Copysign", "Float64bits", "Float64frombits", "Floor", "Frexp", "Inf", "IsInf",
	"IsNaN", "Ldexp", "Signbit", "Sqrt", "Trunc",
}

// The functions of strings and strconv that read tables made from Unicode — package unicode's, or
// strconv's of printable runes — whose version moves with Go's: IDs compare byte by byte.
var unicodeFuncs = map[string][]string{
	"strings": {
		"EqualFold", "Fields", "FieldsSeq", "Title", "ToLower", "ToLowerSpecial", "ToTitle",
		"ToTitleSpecial", "ToUpper", "ToUpperSpecial", "TrimSpace",
	},
	"strconv": {
		"AppendQuote", "AppendQuoteRune", "AppendQuoteRuneToASCII", "AppendQuoteRuneToGraphic",
		"AppendQuoteToASCII", "AppendQuoteToGraphic", "CanBackquote", "IsGraphic", "IsPrint", "Quote",
		"QuoteRune", "QuoteRuneToASCII", "QuoteRuneToGraphic", "QuoteToASCII", "QuoteToGraphic",
	},
}

// Extensions of the files the go command would compile with a tool other than the Go compiler,
// or link in as they are.
var foreignSources = []string{
	".c", ".cc", ".cpp", ".cxx", ".f", ".F", ".f90", ".for", ".h", ".hh", ".hpp", ".hxx", ".m",
	".S", ".s", ".swig", ".swigcxx", ".sx", ".syso",
}

// The names of systems and architectures a file name may end with to constrain its build:
// KnownOS and KnownArch in src/internal/syslist/syslist.go of Go 1.27.3.
var knownOS = []string{
	"aix", "android", "darwin", "dragonfly", "freebsd", "hurd", "illumos", "ios", "js", "linux",
	"nacl", "netbsd", "openbsd", "plan9", "solaris", "wasip1", "windows", "zos",
}

var knownArch = []string{
	"386", "amd64", "amd64p32", "arm", "armbe", "arm64", "arm64be", "loong64", "mips", "mipsle",
	"mips64", "mips64le", "mips64p32", "mips64p32le", "ppc", "ppc64", "ppc64le", "riscv", "riscv64",
	"s390", "s390x", "sparc", "sparc64", "wasm",
}

type finding struct {
	file string // relative to the module's root, with slashes
	line int
	rule string
	msg  string
}

func (f finding) key() string { return fmt.Sprintf("%s:%d: %s", f.file, f.line, f.rule) }

func (f finding) String() string { return fmt.Sprintf("%s: %s", f.key(), f.msg) }

// A package directory of the module: its code, its tests in the package and its external tests.
type packageDir struct {
	path                string // import path
	code, internal, ext []*ast.File
}

type checker struct {
	root, goMod, module string
	lists               Lists
	fset                *token.FileSet
	std                 types.Importer         // of every package from outside the module
	dirs                map[string]*packageDir // by import path
	checked             map[string]*types.Package
	findings            []finding
}

// checkModule checks the module whose go.mod is in root, under the name goMod, by the lists: its
// go.mod, every package directory the go command would build, as it finds them — not testdata, not
// a directory whose name begins with "." or "_", not another module within it — and the modules
// nested in it.
func checkModule(root, goMod string, lists Lists) ([]finding, error) {
	c := &checker{
		root:    root,
		goMod:   goMod,
		lists:   lists,
		fset:    token.NewFileSet(),
		dirs:    map[string]*packageDir{},
		checked: map[string]*types.Package{},
	}
	// Every package from outside the module is type-checked from its sources, for the host: the
	// standard library's, and those of the modules go.mod may require, which go/build finds through
	// the go command by the module's go.mod. One importer for all, so that a type of the standard
	// library in a required module's API is the same type the module sees. The export data of the gc
	// importer would reach the standard library alone. The module's own packages are checked from
	// their sources below. Nothing in a control is outside the standard library: it has no module
	// the go command could resolve. Since the rules allow no build constraint, the code is the same
	// on every target, and one check on the host holds them all.
	c.std = importer.ForCompiler(c.fset, "source", nil)
	if err := c.readGoMod(); err != nil {
		return nil, err
	}
	if err := c.readDir(root, c.module); err != nil {
		return nil, err
	}
	if err := c.checkNested(); err != nil {
		return nil, err
	}
	paths := make([]string, 0, len(c.dirs))
	for path := range c.dirs {
		paths = append(paths, path)
	}
	slices.Sort(paths)
	for _, path := range paths {
		if err := c.checkPackage(c.dirs[path]); err != nil {
			return nil, err
		}
	}
	slices.SortFunc(c.findings, func(a, b finding) int { return strings.Compare(a.String(), b.String()) })
	return slices.CompactFunc(c.findings, func(a, b finding) bool { return a.key() == b.key() }), nil
}

func (c *checker) report(pos token.Pos, rule, format string, args ...any) {
	p := c.fset.Position(pos)
	c.reportAt(p.Filename, p.Line, rule, format, args...)
}

func (c *checker) reportAt(path string, line int, rule, format string, args ...any) {
	rel, err := filepath.Rel(c.root, path)
	if err != nil {
		rel = path
	}
	c.findings = append(c.findings, finding{
		file: filepath.ToSlash(rel), line: line, rule: rule, msg: fmt.Sprintf(format, args...),
	})
}

func (c *checker) readGoMod() error {
	path := filepath.Join(c.root, c.goMod)
	data, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	// A directive names its module after its word, or on each line of its block, whose "(" ends
	// the line of the word, as go.mod has it. A path may be quoted.
	block := "" // the word of the block the line is in
	for i, line := range strings.Split(string(data), "\n") {
		line, _, _ = strings.Cut(line, "//")
		fields := strings.Fields(line)
		word := block
		switch {
		case len(fields) == 0:
			continue
		case block != "" && fields[0] == ")":
			block = ""
			continue
		case block != "":
		case strings.HasSuffix(fields[0], "(") && len(fields) == 1:
			block = strings.TrimSuffix(fields[0], "(")
			continue
		case len(fields) == 2 && fields[1] == "(":
			block = fields[0]
			continue
		default:
			word, fields = fields[0], fields[1:]
		}
		if len(fields) == 0 {
			continue
		}
		mod := fields[0]
		if s, err := strconv.Unquote(mod); err == nil {
			mod = s
		}
		switch word {
		case "module":
			c.module = mod
		case "require":
			if !slices.Contains(c.lists.Requires, mod) {
				c.reportAt(path, i+1, "require", "go.mod requires %s, which the lists do not name among the modules it may require", mod)
			}
		case "replace":
			c.reportAt(path, i+1, "replace", "go.mod replaces %s: a module comes as its release gives it", mod)
		}
	}
	if c.module == "" {
		return fmt.Errorf("%s: no module line", path)
	}
	return nil
}

// checkNested reports every go.mod below the root but those the lists name: the zip of a Go module
// leaves out every nested module — "Module zip files do not include … any nested modules
// (subdirectories that contain go.mod files)" (Go Modules Reference) — so a go.mod below the root
// would take its folder out of what consumers get, and their tests with it. A folder of version
// control, or one that holds one, as a submodule, is not walked: the zip leaves them out too.
func (c *checker) checkNested() error {
	return filepath.WalkDir(c.root, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return err
		}
		if d.IsDir() {
			if _, err := os.Stat(filepath.Join(path, ".git")); (err == nil && path != c.root) || d.Name() == ".git" {
				return filepath.SkipDir
			}
			return nil
		}
		rel, err := filepath.Rel(c.root, path)
		if err != nil {
			return err
		}
		if d.Name() == "go.mod" && rel != "go.mod" && !slices.Contains(c.lists.NestedModules, filepath.ToSlash(filepath.Dir(rel))) {
			c.reportAt(path, 1, "nested", "a nested module, which the zip of the module leaves out")
		}
		return nil
	})
}

func (c *checker) readDir(dir, importPath string) error {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return err
	}
	pkg := &packageDir{path: importPath}
	for _, e := range entries {
		name := e.Name()
		path := filepath.Join(dir, name)
		if strings.HasPrefix(name, ".") || strings.HasPrefix(name, "_") {
			continue
		}
		if e.IsDir() {
			if name == "testdata" {
				continue
			}
			if _, err := os.Stat(filepath.Join(path, "go.mod")); err == nil {
				continue
			}
			if err := c.readDir(path, importPath+"/"+name); err != nil {
				return err
			}
			continue
		}
		ext := filepath.Ext(name)
		if ext != ".go" && !slices.Contains(foreignSources, ext) {
			continue
		}
		if osArchSuffix(name) {
			c.reportAt(path, 1, "buildtag", "the name of %s constrains its build to a system or an architecture", name)
		}
		if ext != ".go" {
			c.reportAt(path, 1, "asm", "%s is no Go source: the code is Go alone", name)
			continue
		}
		f, err := parser.ParseFile(c.fset, path, nil, parser.ParseComments|parser.SkipObjectResolution)
		if err != nil {
			return err
		}
		isTest := strings.HasSuffix(name, "_test.go")
		c.checkSyntax(f, isTest)
		switch {
		case !isTest:
			pkg.code = append(pkg.code, f)
		case strings.HasSuffix(f.Name.Name, "_test"):
			pkg.ext = append(pkg.ext, f)
		default:
			pkg.internal = append(pkg.internal, f)
		}
	}
	if len(pkg.code)+len(pkg.internal)+len(pkg.ext) > 0 {
		c.dirs[importPath] = pkg
	}
	return nil
}

// osArchSuffix tells whether the go command reads the file's name as a build constraint, as
// goodOSArchFile in go/build does: *_GOOS, *_GOARCH or *_GOOS_GOARCH, before an optional _test.
func osArchSuffix(name string) bool {
	name, _, _ = strings.Cut(name, ".")
	i := strings.Index(name, "_")
	if i < 0 {
		return false
	}
	l := strings.Split(name[i:], "_")
	if n := len(l); n > 0 && l[n-1] == "test" {
		l = l[:n-1]
	}
	n := len(l)
	if n >= 2 && slices.Contains(knownOS, l[n-2]) && slices.Contains(knownArch, l[n-1]) {
		return true
	}
	return n >= 1 && (slices.Contains(knownOS, l[n-1]) || slices.Contains(knownArch, l[n-1]))
}

// checkSyntax checks what needs no types: imports and directives.
func (c *checker) checkSyntax(f *ast.File, isTest bool) {
	for _, spec := range f.Imports {
		path, err := strconv.Unquote(spec.Path.Value)
		if err != nil {
			c.report(spec.Pos(), "import", "an import path that does not unquote: %v", err)
			continue
		}
		switch {
		case path == "C":
			c.report(spec.Pos(), "cgo", "cgo: the code is Go alone")
		case path == c.module || strings.HasPrefix(path, c.module+"/"):
		case slices.Contains(c.lists.CodeImports, path):
		case isTest && slices.Contains(c.lists.TestImports, path):
		case isTest:
			c.report(spec.Pos(), "import", "%s is on neither the list of code nor that of tests", path)
		default:
			c.report(spec.Pos(), "import", "%s is not on the list of code", path)
		}
	}
	for _, group := range f.Comments {
		for _, comment := range group.List {
			switch text := comment.Text; {
			case strings.HasPrefix(text, "//go:linkname"):
				c.report(comment.Pos(), "linkname", "//go:linkname reaches past what a package exports")
			case strings.HasPrefix(text, "//go:build"), strings.HasPrefix(strings.TrimLeft(text[2:], " \t"), "+build"):
				c.report(comment.Pos(), "buildtag", "a build constraint: every build compiles the same code")
			}
		}
	}
}

// Import gives the module's own packages from their code, checked here, and every other package
// from its sources, by one importer.
func (c *checker) Import(path string) (*types.Package, error) {
	if pkg, ok := c.checked[path]; ok {
		return pkg, nil
	}
	dir, ok := c.dirs[path]
	if !ok {
		return c.std.Import(path)
	}
	pkg, _, err := c.typeCheck(path, dir.code)
	if err != nil {
		return nil, err
	}
	c.checked[path] = pkg
	return pkg, nil
}

func (c *checker) typeCheck(path string, files []*ast.File) (*types.Package, *types.Info, error) {
	info := &types.Info{
		Types: map[ast.Expr]types.TypeAndValue{},
		Uses:  map[*ast.Ident]types.Object{},
	}
	var errs []string
	conf := types.Config{
		Importer:    c,
		FakeImportC: true,
		Error:       func(err error) { errs = append(errs, err.Error()) },
	}
	pkg, _ := conf.Check(path, c.fset, files, info)
	if len(errs) > 0 {
		return nil, nil, fmt.Errorf("type-checking %s:\n%s", path, strings.Join(errs, "\n"))
	}
	return pkg, info, nil
}

// checkPackage type-checks the package's code, its code with its tests in the package, and its
// external tests, which see those tests too, and checks each file once.
func (c *checker) checkPackage(dir *packageDir) error {
	if len(dir.code) > 0 {
		pkg, info, err := c.typeCheck(dir.path, dir.code)
		if err != nil {
			return err
		}
		if _, ok := c.checked[dir.path]; !ok {
			c.checked[dir.path] = pkg
		}
		for _, f := range dir.code {
			c.checkTyped(f, info, false)
		}
	}
	if len(dir.internal) > 0 {
		// The external tests import the package with its tests in it, and every other package of
		// the module they import is checked again against that one, as the go command builds
		// them: one package, one *types.Package, in the check of the external tests. The package
		// with its tests is itself checked against the packages of that fresh set, so that a type
		// of another package it hands the external tests is the one they see.
		checked := c.checked
		c.checked = map[string]*types.Package{}
		defer func() { c.checked = checked }()
		pkg, info, err := c.typeCheck(dir.path, slices.Concat(dir.code, dir.internal))
		if err != nil {
			return err
		}
		c.checked[dir.path] = pkg
		for _, f := range dir.internal {
			c.checkTyped(f, info, true)
		}
	}
	if len(dir.ext) > 0 {
		_, info, err := c.typeCheck(dir.path+"_test", dir.ext)
		if err != nil {
			return err
		}
		for _, f := range dir.ext {
			c.checkTyped(f, info, true)
		}
	}
	return nil
}

// checkTyped checks what needs types: the arithmetic of floats, the functions of math, strings
// and strconv, however they are named, and in code the ranges over maps and go statements.
func (c *checker) checkTyped(f *ast.File, info *types.Info, isTest bool) {
	ast.PreorderStack(f, nil, func(n ast.Node, stack []ast.Node) bool {
		if e, ok := n.(ast.Expr); ok {
			if tv, ok := info.Types[e]; ok && isKind(tv.Type, types.IsComplex) {
				c.report(e.Pos(), "complex", "a complex value: its arithmetic has no float64() to hold it")
			}
		}
		switch n := n.(type) {
		case *ast.BinaryExpr:
			c.checkBinary(n, stack, info)
		case *ast.AssignStmt:
			c.checkAssign(n, info)
		case *ast.IncDecStmt:
			if tv, ok := info.Types[n.X]; ok && mayBeFloat(tv.Type) {
				c.report(n.TokPos, "typeparam", "arithmetic on a type parameter that may be a float: no float64() holds it")
			}
		case *ast.Ident:
			c.checkFunc(n, info, isTest)
		case *ast.RangeStmt:
			if tv, ok := info.Types[n.X]; ok && !isTest && typeSetHas(tv.Type, isMap) {
				c.report(n.Pos(), "maprange", "a range over a map: its order is not specified")
			}
		case *ast.GoStmt:
			if !isTest {
				c.report(n.Pos(), "goroutine", "a go statement: the code starts no goroutines")
			}
		}
		return true
	})
}

func (c *checker) checkBinary(e *ast.BinaryExpr, stack []ast.Node, info *types.Info) {
	tv := info.Types[e]
	if tv.Value != nil {
		return // a constant: exact, and computed by the compiler
	}
	switch e.Op {
	case token.ADD, token.SUB, token.MUL, token.QUO:
		if mayBeFloat(tv.Type) {
			c.report(e.OpPos, "typeparam", "arithmetic on a type parameter that may be a float: no float64() holds it")
		}
	}
	if (e.Op != token.MUL && e.Op != token.QUO) || !isKind(tv.Type, types.IsFloat) {
		return
	}
	parent := enclosing(stack)
	switch p := parent.(type) {
	case *ast.BinaryExpr:
		switch p.Op {
		case token.MUL, token.QUO, token.EQL, token.NEQ, token.LSS, token.LEQ, token.GTR, token.GEQ:
			return
		}
	case *ast.CallExpr:
		if fun, ok := info.Types[p.Fun]; ok && fun.IsType() && isKind(fun.Type, types.IsFloat) {
			return
		}
	}
	c.report(e.OpPos, "fused", "the result of %s goes on without float64(): the compiler may fuse it", e.Op)
}

// enclosing gives the node that holds the expression, past its parentheses.
func enclosing(stack []ast.Node) ast.Node {
	for i := len(stack) - 1; i >= 0; i-- {
		if _, ok := stack[i].(*ast.ParenExpr); !ok {
			return stack[i]
		}
	}
	return nil
}

func (c *checker) checkAssign(s *ast.AssignStmt, info *types.Info) {
	switch s.Tok {
	case token.ADD_ASSIGN, token.SUB_ASSIGN, token.MUL_ASSIGN, token.QUO_ASSIGN:
	default:
		return
	}
	tv, ok := info.Types[s.Lhs[0]]
	if !ok {
		return
	}
	if mayBeFloat(tv.Type) {
		c.report(s.TokPos, "typeparam", "arithmetic on a type parameter that may be a float: no float64() holds it")
	}
	if (s.Tok == token.MUL_ASSIGN || s.Tok == token.QUO_ASSIGN) && isKind(tv.Type, types.IsFloat) {
		c.report(s.TokPos, "assignop", "%s on a float: its result cannot go through float64()", s.Tok)
	}
}

// checkFunc checks a use of a function of math, strings or strconv, as math.Exp or, imported
// with a dot, as Exp.
func (c *checker) checkFunc(id *ast.Ident, info *types.Info, isTest bool) {
	fn, ok := info.Uses[id].(*types.Func)
	if !ok || fn.Pkg() == nil {
		return
	}
	name := fn.Name()
	switch path := fn.Pkg().Path(); path {
	case "math":
		if !slices.Contains(mathFuncs, name) && !(isTest && slices.Contains(c.lists.TestMath, name)) {
			c.report(id.Pos(), "math", "math.%s: its result is not defined exactly on every build", name)
		}
	case "strings", "strconv":
		if !isTest && slices.Contains(unicodeFuncs[path], name) {
			c.report(id.Pos(), "unicode", "%s.%s reads the Unicode tables of this Go: compare bytes", path, name)
		}
	}
}

func isKind(t types.Type, kind types.BasicInfo) bool {
	if t == nil {
		return false
	}
	b, ok := t.Underlying().(*types.Basic)
	return ok && b.Info()&kind != 0
}

func isMap(t types.Type) bool {
	_, ok := t.Underlying().(*types.Map)
	return ok
}

// mayBeFloat tells whether t is a type parameter whose type set holds a float or a complex type.
func mayBeFloat(t types.Type) bool {
	if _, ok := t.(*types.TypeParam); !ok {
		return false
	}
	return typeSetHas(t, func(t types.Type) bool { return isKind(t, types.IsFloat|types.IsComplex) })
}

// typeSetHas tells whether t has the property, or, as a type parameter, whether a type of its
// constraint's type set has it.
func typeSetHas(t types.Type, has func(types.Type) bool) bool {
	tp, ok := t.(*types.TypeParam)
	if !ok {
		return has(t)
	}
	iface, ok := tp.Constraint().Underlying().(*types.Interface)
	return ok && interfaceHas(iface, has)
}

func interfaceHas(iface *types.Interface, has func(types.Type) bool) bool {
	for i := range iface.NumEmbeddeds() {
		if termHas(iface.EmbeddedType(i), has) {
			return true
		}
	}
	return false
}

func termHas(t types.Type, has func(types.Type) bool) bool {
	switch u := t.Underlying().(type) {
	case *types.Union:
		for i := range u.Len() {
			if termHas(u.Term(i).Type(), has) {
				return true
			}
		}
		return false
	case *types.Interface:
		return interfaceHas(u, has)
	}
	return has(t)
}
