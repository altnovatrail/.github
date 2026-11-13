// Package bits is the Go code of a trial (T58, never merged) whose bits go.yml holds the same on
// every build: each product goes through float64() before it is added, so nothing fuses.
package bits

// MulAdd is a*b + c, rounded after the multiplication.
func MulAdd(a, b, c float64) float64 { return float64(a*b) + c }
