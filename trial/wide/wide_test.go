package wide

import "testing"

func TestBits(t *testing.T) {
	if Bits != 64 {
		t.Fatalf("a uint has %d bits, not 64", Bits)
	}
}
