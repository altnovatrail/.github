// A trial for T19 of RUN.md, never merged: a command run from what a request says, which
// CodeQL's go/command-injection is meant to find.
package main

import (
	"net/http"
	"os/exec"
)

func handler(w http.ResponseWriter, r *http.Request) {
	out, _ := exec.Command("sh", "-c", r.URL.Query().Get("cmd")).Output()
	_, _ = w.Write(out)
}

func main() {
	http.HandleFunc("/", handler)
	_ = http.ListenAndServe("127.0.0.1:8080", nil)
}
