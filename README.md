# __REPO_NAME__

> One-line description of `__PKG_NAME__` goes here.

[![Go Reference](https://pkg.go.dev/badge/__MODULE_PATH__.svg)](https://pkg.go.dev/__MODULE_PATH__)
[![Tests](https://github.com/__GH_USER__/__REPO_NAME__/actions/workflows/test.yml/badge.svg)](https://github.com/__GH_USER__/__REPO_NAME__/actions/workflows/test.yml)
[![CodeQL](https://github.com/__GH_USER__/__REPO_NAME__/actions/workflows/codeql.yml/badge.svg)](https://github.com/__GH_USER__/__REPO_NAME__/actions/workflows/codeql.yml)
[![Go Report Card](https://goreportcard.com/badge/__MODULE_PATH__)](https://goreportcard.com/report/__MODULE_PATH__)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Install

```bash
go get __MODULE_PATH__
```

## Usage

```go
package main

import (
	"fmt"

	"__MODULE_PATH__"
)

func main() {
	fmt.Println(__PKG_NAME__.Hello())
}
```

## Compatibility

Supports Go 1.24 and later. CI runs against the floor (1.24) plus the two newest released toolchains.

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md). Conventional Commits are enforced on PR titles.

## License

[MIT](./LICENSE)
