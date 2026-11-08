package main

import (
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"os"
)

// Lists is what a caller's .github/coderules.json says its code and tests may take, beside the
// standard library's packages the rules allow everyone (R107 in spec). Every field is a list,
// empty when the file leaves it out:
//
//   - code-imports: the packages code may import, beside the module's own;
//   - test-imports: what tests may import beside them;
//   - test-math: the functions of math tests may call beside those the rules allow, as the
//     standard that code's own exp and log are measured against;
//   - requires: the modules go.mod may require;
//   - nested-modules: the folders, relative to the root and with slashes, whose go.mod may sit
//     below the root, as a lock file of a tool that no code reads.
type Lists struct {
	CodeImports   []string `json:"code-imports"`
	TestImports   []string `json:"test-imports"`
	TestMath      []string `json:"test-math"`
	Requires      []string `json:"requires"`
	NestedModules []string `json:"nested-modules"`
}

// readLists reads the lists of path: one JSON object with no field but those above, and nothing
// after it. A field it does not know is a mistake, a word mistyped, and not a list left empty.
func readLists(path string) (Lists, error) {
	var lists Lists
	data, err := os.ReadFile(path)
	if err != nil {
		return lists, fmt.Errorf("the lists: %w", err)
	}
	dec := json.NewDecoder(bytes.NewReader(data))
	dec.DisallowUnknownFields()
	if err := dec.Decode(&lists); err != nil {
		return lists, fmt.Errorf("the lists, %s: %w", path, err)
	}
	if err := dec.Decode(new(json.RawMessage)); !errors.Is(err, io.EOF) {
		return lists, fmt.Errorf("the lists, %s: something follows the object", path)
	}
	return lists, nil
}
