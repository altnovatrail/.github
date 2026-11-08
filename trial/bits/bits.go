// Package bits is the Go code of a trial (T48, never merged) that keeps the rules of code: each
// product goes through float64() before it is added, and math gives only what it defines exactly.
package bits

import "math"

// MulAdd is a*b + |c|, rounded after the multiplication.
func MulAdd(a, b, c float64) float64 { return float64(a*b) + math.Abs(c) }
