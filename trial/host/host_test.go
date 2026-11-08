// Package host is the negative half of the trial (T47, never merged): a test that holds only on an
// amd64 host, so that "Go / arm64" alone fails it.
package host

import (
	"runtime"
	"testing"
)

func TestHost(t *testing.T) {
	if runtime.GOARCH == "arm64" {
		t.Fatal("the trial fails on arm64 alone")
	}
}
