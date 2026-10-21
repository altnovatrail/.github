// A trial for T19 of RUN.md, never merged: the same program, now running a fixed command.
package main

import (
	"net/http"
	"os/exec"
)

func handler(w http.ResponseWriter, _ *http.Request) {
	out, _ := exec.Command("date", "-u").Output()
	_, _ = w.Write(out)
}

func main() {
	http.HandleFunc("/", handler)
	_ = http.ListenAndServe("127.0.0.1:8080", nil)
}
