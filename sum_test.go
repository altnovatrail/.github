package trial

import "testing"

func TestSum(t *testing.T) {
	if Sum(2, 3) != 5 {
		t.Fatal("2 + 3 is not 5")
	}
}
