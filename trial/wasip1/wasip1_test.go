// Package wasip1 is the negative half of the trial (T58, never merged): a test that holds
// everywhere but on wasip1, so that "Go / targets" and "Go / arm64" alone fail it, on wasip1.
package wasip1

import (
	"runtime"
	"testing"
)

func TestNotOnWasip1(t *testing.T) {
	if runtime.GOOS == "wasip1" {
		t.Fatal("the trial fails on wasip1 alone")
	}
}
