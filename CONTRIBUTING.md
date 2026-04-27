# Contributing

## Development setup

Requirements:
- Go 1.24 or later
- [golangci-lint](https://golangci-lint.run/usage/install/) (v2)
- git

```bash
git clone https://github.com/__GH_USER__/__REPO_NAME__.git
cd __REPO_NAME__

go mod download

go test -v -race ./...
go test -v -race -coverprofile=coverage.txt -covermode=atomic ./...

golangci-lint run
go vet ./...
gofmt -s -l .
```

## Pull request guidelines

- **Conventional Commits**: PR titles must match `^(feat|fix|chore|ci|docs|refactor|test|perf|build|revert|style)(\([a-z0-9_./-]+\))?!?: .+`. The squash-merge commit subject is the PR title.
- **Tests required** for new features and bug fixes. Use table-driven tests; cover edge cases.
- **Godoc**: every exported identifier needs a doc comment that starts with the identifier name.
- **CHANGELOG**: add an entry under `## [Unreleased]` for features and fixes.

## Releases

1. Open a PR from a `release/vX.Y.Z` branch (e.g. `release/v0.3.0`) into `main`.
2. The PR should bump the `## [Unreleased]` heading to `## [vX.Y.Z] - YYYY-MM-DD`.
3. Merging the release PR triggers `auto-tag.yml`, which creates the tag and a GitHub Release linking to the CHANGELOG.

## Test policy

- Coverage gate floor is 85% (configured in `.github/workflows/test.yml`). Adjust `MIN_COVERAGE` per project as needed.
- Fuzz targets (any `func FuzzFoo(*testing.F)` in `*_test.go`) run on the floor toolchain only with a 10s budget per target. Add new fuzz targets freely — they're auto-discovered by CI.
- Race detector is on for all matrix legs.

## Security

See [SECURITY.md](./SECURITY.md). Do not file public issues for security vulnerabilities.
