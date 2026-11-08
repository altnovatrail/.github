// Package broken is the negative half of the trial (T48, never merged): code that breaks the rules
// of code, which "Go / rules" must name.
package broken

import (
	"math"
	"os"
)

// Bad fuses a product, calls math.Exp and starts a goroutine.
func Bad(a, b, c float64) float64 {
	_ = os.Args
	go func() {}()
	return a*b + math.Exp(c)
}
