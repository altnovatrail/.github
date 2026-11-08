package main

import (
	"bytes"
	"fmt"
	"os"
	"path/filepath"
	"slices"
	"strings"
	"testing"
)

// The controls: modules that break every rule, each by the lists of a module that kept its own
// copy of this check, learner-model's and engine's. Each keeps its go.mod as go.mod.control and its
// lists as coderules.json, and marks every line it breaks a rule on with "// want <rule>".
var controls = []string{"learner-model", "engine"}

// TestControls holds the check to its controls: every finding the "// want" comments of a control
// name, none they do not, so that a weakened check fails, and a stricter one too.
func TestControls(t *testing.T) {
	for _, name := range controls {
		t.Run(name, func(t *testing.T) {
			root := filepath.Join("testdata", name)
			lists, err := readLists(filepath.Join(root, "coderules.json"))
			if err != nil {
				t.Fatal(err)
			}
			found, err := checkModule(root, "go.mod.control", lists)
			if err != nil {
				t.Fatal(err)
			}
			want, err := wantedFindings(root)
			if err != nil {
				t.Fatal(err)
			}
			got := map[string]bool{}
			for _, f := range found {
				got[f.key()] = true
				if !slices.ContainsFunc(want, func(w finding) bool { return w.key() == f.key() }) {
					t.Errorf("not wanted: %s", f)
				}
			}
			for _, w := range want {
				if !got[w.key()] {
					t.Errorf("wanted, not found: %s", w.key())
				}
			}
		})
	}
}

// TestEveryRuleIsBroken holds the controls to every rule: a rule no control breaks would go
// unchecked.
func TestEveryRuleIsBroken(t *testing.T) {
	var want []finding
	for _, name := range controls {
		w, err := wantedFindings(filepath.Join("testdata", name))
		if err != nil {
			t.Fatal(err)
		}
		want = append(want, w...)
	}
	for _, rule := range allRules {
		if !slices.ContainsFunc(want, func(w finding) bool { return w.rule == rule }) {
			t.Errorf("no control breaks the rule %q", rule)
		}
	}
}

// The lists of the controls differ where learner-model and engine differ: the same control with
// the other's lists finds what those allow it, so that the check reads the lists it is given.
func TestTheListsDecide(t *testing.T) {
	lists, err := readLists(filepath.Join("testdata", "engine", "coderules.json"))
	if err != nil {
		t.Fatal(err)
	}
	found, err := checkModule(filepath.Join("testdata", "learner-model"), "go.mod.control", lists)
	if err != nil {
		t.Fatal(err)
	}
	keys := map[string]bool{}
	for _, f := range found {
		keys[f.key()] = true
	}
	// engine's lists allow no math.Exp in tests and no folder of gopls nested.
	for _, key := range []string{
		"control_test.go:17: math",
		".devcontainer/gopls/go.mod:1: nested",
	} {
		if !keys[key] {
			t.Errorf("with engine's lists, no finding %s", key)
		}
	}
}

// The other way round, learner-model's lists allow engine's control encoding/binary and
// unicode/utf8 in code, which engine's lists refuse: code-imports decide too.
func TestTheCodeImportsDecide(t *testing.T) {
	root := filepath.Join("testdata", "engine")
	lists, err := readLists(filepath.Join("testdata", "learner-model", "coderules.json"))
	if err != nil {
		t.Fatal(err)
	}
	found, err := checkModule(root, "go.mod.control", lists)
	if err != nil {
		t.Fatal(err)
	}
	data, err := os.ReadFile(filepath.Join(root, "control.go"))
	if err != nil {
		t.Fatal(err)
	}
	lines := 0
	for i, line := range strings.Split(string(data), "\n") {
		if !strings.Contains(line, `"encoding/binary"`) && !strings.Contains(line, `"unicode/utf8"`) {
			continue
		}
		lines++
		key := fmt.Sprintf("control.go:%d: import", i+1)
		if slices.ContainsFunc(found, func(f finding) bool { return f.key() == key }) {
			t.Errorf("with learner-model's lists, %s", key)
		}
	}
	if lines != 2 {
		t.Fatalf("the control imports encoding/binary and unicode/utf8 on %d lines, not 2", lines)
	}
}

func TestListsRefuseWhatTheyDoNotKnow(t *testing.T) {
	dir := t.TempDir()
	for name, text := range map[string]string{
		"unknown.json":  `{"code-imports": [], "code-import": ["os"]}`,
		"trailing.json": `{"code-imports": []} {}`,
		"broken.json":   `{"code-imports": [`,
		"array.json":    `[]`,
	} {
		path := filepath.Join(dir, name)
		if err := os.WriteFile(path, []byte(text), 0o644); err != nil {
			t.Fatal(err)
		}
		if _, err := readLists(path); err == nil {
			t.Errorf("%s: read, though it is %s", name, text)
		}
	}
	if _, err := readLists(filepath.Join(dir, "none.json")); err == nil {
		t.Error("lists that are not there: read")
	}
	path := filepath.Join(dir, "empty.json")
	if err := os.WriteFile(path, []byte(`{}`), 0o644); err != nil {
		t.Fatal(err)
	}
	if lists, err := readLists(path); err != nil || len(lists.CodeImports)+len(lists.Requires) != 0 {
		t.Errorf("{}: %+v, %v; want empty lists", lists, err)
	}
}

// A module of its own in a folder of the test, with go.mod and the lists beside it.
func module(t *testing.T, files map[string]string) string {
	t.Helper()
	dir := t.TempDir()
	for name, text := range files {
		path := filepath.Join(dir, filepath.FromSlash(name))
		if err := os.MkdirAll(filepath.Dir(path), 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, []byte(text), 0o644); err != nil {
			t.Fatal(err)
		}
	}
	return dir
}

func TestRun(t *testing.T) {
	clean := map[string]string{
		"go.mod":           "module example.com/clean\n\ngo 1.27\n",
		"lists.json":       `{"code-imports": ["math"]}`,
		"clean.go":         "package clean\n\nimport \"math\"\n\nfunc F(a, b, c float64) float64 { return float64(a*b) + math.Abs(c) }\n",
		".git/HEAD":        "a folder of version control, which the check does not walk\n",
		"sub/.git/HEAD":    "a submodule\n",
		"sub/inner/go.mod": "module example.com/submodule\n",
	}
	broken := map[string]string{
		"go.mod":     "module example.com/broken\n\ngo 1.27\n",
		"lists.json": `{}`,
		"fused.go":   "package broken\n\nfunc F(a, b, c float64) float64 { return a*b + c }\n",
	}
	for _, tc := range []struct {
		name   string
		files  map[string]string
		args   func(dir string) []string
		status int
		stdout string
		stderr string
	}{
		{"clean", clean, func(d string) []string { return []string{"-lists", filepath.Join(d, "lists.json"), d} }, 0, "", ""},
		{"broken", broken, func(d string) []string { return []string{"-lists", filepath.Join(d, "lists.json"), d} }, 1,
			"fused.go:3: fused: the result of * goes on without float64(): the compiler may fuse it\n", "coderules: 1 findings\n"},
		{"no lists", clean, func(d string) []string { return []string{"-lists", filepath.Join(d, "none.json"), d} }, 2, "", "coderules: the lists: "},
		{"no module", clean, func(d string) []string {
			return []string{"-lists", filepath.Join(d, "lists.json"), filepath.Join(d, "sub")}
		}, 2, "", "coderules: "},
		{"no flag", clean, func(d string) []string { return []string{d} }, 2, "", "usage: coderules -lists <file> <the root of the module>\n"},
		{"two folders", clean, func(d string) []string { return []string{"-lists", "x", d, d} }, 2, "", "usage: "},
		{"unknown flag", clean, func(d string) []string { return []string{"-list", "x", d} }, 2, "", "flag provided but not defined: -list"},
	} {
		t.Run(tc.name, func(t *testing.T) {
			dir := module(t, tc.files)
			var stdout, stderr bytes.Buffer
			status := run(tc.args(dir), &stdout, &stderr)
			if status != tc.status {
				t.Errorf("exit status %d, want %d; stderr %q", status, tc.status, stderr.String())
			}
			if stdout.String() != tc.stdout {
				t.Errorf("stdout %q, want %q", stdout.String(), tc.stdout)
			}
			if !strings.HasPrefix(stderr.String(), tc.stderr) && !strings.Contains(stderr.String(), tc.stderr) {
				t.Errorf("stderr %q, want it to hold %q", stderr.String(), tc.stderr)
			}
		})
	}
}

// wantedFindings reads the comments "// want <rule> ..." of every file under root, at their lines.
func wantedFindings(root string) ([]finding, error) {
	var want []finding
	err := walkFiles(root, func(path string) error {
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		rel, err := filepath.Rel(root, path)
		if err != nil {
			return err
		}
		for i, line := range strings.Split(string(data), "\n") {
			_, rules, ok := strings.Cut(line, "// want ")
			if !ok {
				continue
			}
			for _, rule := range strings.Fields(rules) {
				if !slices.Contains(allRules, rule) {
					return fmt.Errorf("%s:%d: no rule %q", rel, i+1, rule)
				}
				want = append(want, finding{file: filepath.ToSlash(rel), line: i + 1, rule: rule})
			}
		}
		return nil
	})
	return want, err
}

func walkFiles(dir string, visit func(path string) error) error {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return err
	}
	for _, e := range entries {
		path := filepath.Join(dir, e.Name())
		if e.IsDir() {
			err = walkFiles(path, visit)
		} else {
			err = visit(path)
		}
		if err != nil {
			return err
		}
	}
	return nil
}

// A module the check cannot read stops it with the reason, rather than passing with no findings.
func TestUnreadableModules(t *testing.T) {
	for _, tc := range []struct {
		name  string
		files map[string]string
		want  string
	}{
		{"no go.mod", map[string]string{"a.go": "package a\n"}, "go.mod"},
		{"no module line", map[string]string{"go.mod": "go 1.27\n", "a.go": "package a\n"}, "no module line"},
		{"no Go", map[string]string{"go.mod": "module example.com/a\n", "a.go": "package\n"}, "expected 'IDENT'"},
		{"no type", map[string]string{"go.mod": "module example.com/a\n", "a.go": "package a\n\nvar _ = undefined\n"}, "type-checking example.com/a"},
		{"no type in a test", map[string]string{"go.mod": "module example.com/a\n", "a.go": "package a\n", "a_test.go": "package a\n\nvar _ = undefined\n"}, "type-checking example.com/a"},
		{"no type in an external test", map[string]string{"go.mod": "module example.com/a\n", "a.go": "package a\n", "x_test.go": "package a_test\n\nvar _ = undefined\n"}, "type-checking example.com/a_test"},
		{"an import cycle", map[string]string{"go.mod": "module example.com/a\n", "b/b.go": "package b\n\nimport _ \"example.com/a/c\"\n", "c/c.go": "package c\n\nimport _ \"example.com/a/b\"\n"}, "an import cycle through example.com/a/"},
	} {
		t.Run(tc.name, func(t *testing.T) {
			_, err := checkModule(module(t, tc.files), "go.mod", Lists{})
			if err == nil || !strings.Contains(err.Error(), tc.want) {
				t.Errorf("the error is %v; want one that holds %q", err, tc.want)
			}
		})
	}
}

// What the check found before a package stopped it still comes out, with the reason: two files
// whose names constrain their builds declare the same function, so the host type-check fails.
func TestFindingsBeforeAFailureComeOut(t *testing.T) {
	dir := module(t, map[string]string{
		"go.mod":       "module example.com/a\n",
		"a_linux.go":   "package a\n\nfunc f() {}\n",
		"a_windows.go": "package a\n\nfunc f() {}\n",
	})
	var stdout, stderr bytes.Buffer
	lists := filepath.Join(dir, "lists.json")
	if err := os.WriteFile(lists, []byte("{}"), 0o644); err != nil {
		t.Fatal(err)
	}
	if status := run([]string{"-lists", lists, dir}, &stdout, &stderr); status != 2 {
		t.Errorf("exit status %d, want 2", status)
	}
	for _, want := range []string{"a_linux.go:1: buildtag", "a_windows.go:1: buildtag"} {
		if !strings.Contains(stdout.String(), want) {
			t.Errorf("stdout %q holds no %s", stdout.String(), want)
		}
	}
	if !strings.Contains(stderr.String(), "type-checking example.com/a") {
		t.Errorf("stderr %q gives no reason", stderr.String())
	}
}

// go.mod with an empty block on one line requires nothing.
func TestAnEmptyBlockRequiresNothing(t *testing.T) {
	dir := module(t, map[string]string{
		"go.mod": "module example.com/a\n\ngo 1.27\n\nrequire ()\n\nrequire(\n)\n",
		"a.go":   "package a\n",
	})
	found, err := checkModule(dir, "go.mod", Lists{})
	if err != nil || len(found) != 0 {
		t.Errorf("findings %v, error %v; want none", found, err)
	}
}
