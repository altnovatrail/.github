// Package wide is the negative half of the trial (T46, never merged): its test holds only where a
// uint has 64 bits, so that the build for 386 fails it.
package wide

// Bits is the width of a uint.
const Bits = 32 << (^uint(0) >> 63)
