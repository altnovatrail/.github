package bits

import (
	"os"
	"testing"
)

func TestMulAdd(t *testing.T) {
	if got := MulAdd(0.1, 10, -1); got != 0 {
		t.Fatalf("MulAdd(0.1, 10, -1) is %v, not 0", got)
	}
}

// TestReadsTheModule reads go.mod from the folder of the package, as go test runs it: on wasip1
// through the preopened root and PWD.
func TestReadsTheModule(t *testing.T) {
	if _, err := os.ReadFile("../../go.mod"); err != nil {
		t.Fatal(err)
	}
}
