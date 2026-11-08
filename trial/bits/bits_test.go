package bits

import "testing"

func TestMulAdd(t *testing.T) {
	if got := MulAdd(0.1, 10, -1); got != 2 {
		t.Fatalf("MulAdd(0.1, 10, -1) is %v, not 2", got)
	}
}
