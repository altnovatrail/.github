package dep

import "testing"

func TestNewer(t *testing.T) {
	if !Newer("v1.2.0", "v1.1.9") || Newer("v1.0.0", "v1.0.0") {
		t.Fatal("semver.Compare is not what the trial expects")
	}
}
