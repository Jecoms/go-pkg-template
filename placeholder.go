// Package placeholder is a placeholder package shipped with go-pkg-template.
//
// scripts/setup.sh renames this file (and placeholder_test.go) to <pkg>.go
// and <pkg>_test.go, and rewrites the package declaration. Replace the
// contents with your package's real code afterward.
package placeholder

// Hello returns a placeholder greeting. Delete this once your package has
// real exports.
func Hello() string {
	return "hello from placeholder"
}
