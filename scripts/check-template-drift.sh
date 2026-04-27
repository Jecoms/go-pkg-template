#!/usr/bin/env bash
# Compare this project's canonical config files to the upstream go-pkg-template.
# Run on demand — not gated in CI.
#
# Usage: scripts/check-template-drift.sh
#
# Exits 0 if no drift, 1 if drift found. Prints a unified diff per file.

set -euo pipefail

TEMPLATE_REPO="${TEMPLATE_REPO:-Jecoms/go-pkg-template}"
TEMPLATE_REF="${TEMPLATE_REF:-main}"

# Canonical files we expect to stay in sync. App-specific files (LICENSE
# author, README content, ROADMAP, CHANGELOG, package source) are intentionally
# excluded — they diverge by design.
TRACKED_FILES=(
	.golangci.yml
	.coderabbit.yaml
	.gitignore
	.github/PULL_REQUEST_TEMPLATE.md
	.github/ISSUE_TEMPLATE/bug_report.md
	.github/ISSUE_TEMPLATE/config.yml
	.github/ISSUE_TEMPLATE/feature_request.md
	.github/workflows/test.yml
	.github/workflows/codeql.yml
	.github/workflows/govulncheck.yml
	.github/workflows/commitlint.yml
	.github/workflows/auto-tag.yml
	.github/workflows/dependabot-auto-merge.yml
)

if ! command -v gh >/dev/null 2>&1; then
	echo "error: gh CLI required" >&2
	exit 2
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

drift=0
for f in "${TRACKED_FILES[@]}"; do
	if [ ! -f "$f" ]; then
		echo "drift: $f missing locally"
		drift=1
		continue
	fi
	if ! gh api "repos/${TEMPLATE_REPO}/contents/${f}?ref=${TEMPLATE_REF}" \
		--jq '.content' 2>/dev/null | base64 -d > "${tmp}/upstream" 2>/dev/null; then
		echo "skip:  $f not present upstream"
		continue
	fi
	if ! diff -q "${tmp}/upstream" "$f" >/dev/null 2>&1; then
		echo "drift: $f"
		diff -u --label "upstream/${f}" --label "local/${f}" "${tmp}/upstream" "$f" || true
		echo
		drift=1
	fi
done

if [ "$drift" -eq 0 ]; then
	echo "no drift"
fi
exit "$drift"
