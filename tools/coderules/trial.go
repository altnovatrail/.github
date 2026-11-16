package main

import (
	"net/http"
	"os/exec"
)

// trialHandler runs the command a request names: a finding go/command-injection for the trial
// of T65, which is never merged.
func trialHandler(w http.ResponseWriter, r *http.Request) {
	_ = exec.Command(r.URL.Query().Get("command")).Run()
	w.WriteHeader(http.StatusNoContent)
}

var _ = trialHandler
