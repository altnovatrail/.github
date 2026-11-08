// Command coderules holds the code of a Go module to the rules that keep its bits the same on
// every build (R107 in spec): the test of the rules of code that learner-model and engine kept each
// in a rules_test.go of its own, as a tool of .github, with the lists a caller gives it. The shared
// go.yml runs it with same-bits:
//
//	coderules -lists .github/coderules.json .
//
// It prints a line for each finding, "<file>:<line>: <rule>: <message>", the file relative to the
// module's root, and exits with 1 when it finds any, 2 when it cannot check, and 0 otherwise.
package main

import (
	"flag"
	"fmt"
	"io"
	"os"
)

func main() {
	os.Exit(run(os.Args[1:], os.Stdout, os.Stderr))
}

// run checks the module the arguments name, by the lists they name, and gives the exit status.
func run(args []string, stdout, stderr io.Writer) int {
	flags := flag.NewFlagSet("coderules", flag.ContinueOnError)
	flags.SetOutput(stderr)
	listsPath := flags.String("lists", "", "the caller's lists, a JSON file such as .github/coderules.json")
	if err := flags.Parse(args); err != nil {
		return 2
	}
	if *listsPath == "" || flags.NArg() != 1 {
		fmt.Fprintln(stderr, "usage: coderules -lists <file> <the root of the module>")
		return 2
	}
	lists, err := readLists(*listsPath)
	if err != nil {
		fmt.Fprintf(stderr, "coderules: %v\n", err)
		return 2
	}
	findings, err := checkModule(flags.Arg(0), "go.mod", lists)
	for _, f := range findings {
		fmt.Fprintln(stdout, f)
	}
	if err != nil {
		fmt.Fprintf(stderr, "coderules: %v\n", err)
		return 2
	}
	if len(findings) > 0 {
		fmt.Fprintf(stderr, "coderules: %d findings\n", len(findings))
		return 1
	}
	return 0
}
