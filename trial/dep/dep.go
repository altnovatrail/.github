// Package dep is the trial's code with a module to download, so that go mod verify has one to check.
package dep

import "golang.org/x/mod/semver"

// Newer reports whether the version a is newer than b.
func Newer(a, b string) bool { return semver.Compare(a, b) > 0 }
