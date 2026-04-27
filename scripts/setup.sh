#!/usr/bin/env bash
# First-clone setup: replace placeholders with your project's metadata.
# Run once after `gh repo create <name> --template Jecoms/go-pkg-template --public`.

set -euo pipefail

if [ "$#" -lt 5 ]; then
	cat <<'EOF'
Usage: scripts/setup.sh <gh-user> <repo-name> <module-path> <pkg-name> <author-name> [year]

  <gh-user>      GitHub username/org, e.g. "Jecoms"
  <repo-name>    GitHub repo name, e.g. "regextra"
  <module-path>  Go module path, e.g. "github.com/Jecoms/regextra"
  <pkg-name>     Go package name, e.g. "regextra" (must match a valid Go ident)
  <author-name>  LICENSE author, e.g. "Jesse Smith"
  [year]         optional copyright year (defaults to current year)

Replaces __GH_USER__, __REPO_NAME__, __MODULE_PATH__, __PKG_NAME__,
__AUTHOR_NAME__, __YEAR__ across the project. Renames the placeholder
package source files. Then deletes itself.
EOF
	exit 1
fi

GH_USER="$1"
REPO_NAME="$2"
MODULE_PATH="$3"
PKG_NAME="$4"
AUTHOR_NAME="$5"
YEAR="${6:-$(date +%Y)}"

# Validate Go package name (lowercase letters/digits/underscore, starts with letter).
if ! [[ "$PKG_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
	echo "error: pkg-name '$PKG_NAME' is not a valid Go package identifier (lowercase letters/digits/underscore)" >&2
	exit 2
fi

# Portable in-place sed (macOS + Linux).
sedi() {
	if [ "$(uname)" = "Darwin" ]; then sed -i '' "$@"; else sed -i "$@"; fi
}

# Files that contain placeholders. Walk explicit set rather than -R to avoid
# touching .git/ or generated files.
PLACEHOLDER_FILES=(
	go.mod
	placeholder.go
	placeholder_test.go
	LICENSE
	README.md
	CONTRIBUTING.md
	SECURITY.md
	.github/dependabot.yml
)

for f in "${PLACEHOLDER_FILES[@]}"; do
	[ -f "$f" ] || continue
	sedi -e "s|__GH_USER__|${GH_USER}|g" \
		-e "s|__REPO_NAME__|${REPO_NAME}|g" \
		-e "s|__MODULE_PATH__|${MODULE_PATH}|g" \
		-e "s|__PKG_NAME__|${PKG_NAME}|g" \
		-e "s|placeholder|${PKG_NAME}|g" \
		-e "s|__AUTHOR_NAME__|${AUTHOR_NAME}|g" \
		-e "s|__YEAR__|${YEAR}|g" \
		"$f"
done

# Rename placeholder source files to use the actual package name.
mv placeholder.go "${PKG_NAME}.go"
mv placeholder_test.go "${PKG_NAME}_test.go"

# Verify no placeholders remain.
if grep -RIn -E "__(GH_USER|REPO_NAME|MODULE_PATH|AUTHOR_NAME|YEAR)__" \
	--include='*.go' --include='*.mod' --include='*.md' --include='*.yml' --include='LICENSE' \
	. 2>/dev/null; then
	echo "warning: placeholders remain — review above" >&2
fi

rm -- "$0"
echo "Setup complete. Removed scripts/setup.sh."
echo "Next: go test ./... && git add -A && git commit -m 'chore: initial commit'"
