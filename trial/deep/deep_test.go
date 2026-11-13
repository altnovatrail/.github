// Package deep is the second trial of T58 (never merged): a test that recurses 100,000 deep, red
// on wasip1 on Node's default stack and green with the stack of js/wasm.
package deep

import "testing"

func down(n int) int {
	var pad [8]int64
	pad[n%8] = int64(n)
	if n == 0 {
		return int(pad[0])
	}
	return down(n-1) + int(pad[n%8]&1)
}

func TestDeep(t *testing.T) { _ = down(100000) }
