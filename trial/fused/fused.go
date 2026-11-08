// Package fused is the negative half of the trial (T46, never merged): a*b + c without float64(),
// which the compiler fuses where it can.
package fused

// MulAdd is a*b + c, fused on every target that fuses.
func MulAdd(a, b, c float64) float64 { return a*b + c }
