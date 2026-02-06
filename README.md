# Thalia

> A fast, statically typed, general-purpose, procedural programming language written in Ocaml

[![Version: v0.0.0](https://img.shields.io/badge/version-v0.0.0-red)](https://github.com/thalia-lang/thalia-ocaml)
[![License: LGPL v3](https://img.shields.io/badge/License-LGPL%20v3-blue.svg)](http://www.gnu.org/licenses/lgpl-3.0)

## Contents

- [Features](#features)
- [Prerequisites](#prerequisites)
- [Building](#building)
- [Testing](#testing)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)

## Features

- **Statically Typed**: Compile-time type checking for safer code
- **Procedural Paradigm**: Clear, imperative programming style
- **Fast Execution**: Optimized for performance

## Prerequisites

Before building Thalia, ensure you have the following installed:

- **OCaml** - OCaml compiler (v4.14.0 or later recommended)
- **Dune** - OCaml build system (v3.16 or later)
- **OPAM** - OCaml package manager (optional but recommended)

### Required OCaml Packages

- `ppx_deriving` - PPX extension for deriving
- `ppx_inline_test` - Inline testing support

### Installing Prerequisites

**Using OPAM (recommended):**
```bash
# Install OPAM if not already installed
# See: https://opam.ocaml.org/doc/Install.html

# Initialize OPAM
opam init

# Install OCaml compiler
opam switch create 4.14.0

# Install dependencies
opam install dune ppx_deriving ppx_inline_test
```

### Dune Commands Reference

| Command                 | Description                              |
|------------------------|------------------------------------------|
| `dune build`           | Build the project                        |
| `dune build --release` | Build with optimizations                 |
| `dune exec thalia`     | Run the thalia executable                |
| `dune test`            | Run all tests                            |
| `dune clean`           | Remove build artifacts                   |
| `dune install`         | Install the executable                   |
| `dune uninstall`       | Uninstall the executable                 |
| `dune build --watch`   | Continuous build on file changes         |

## Building

### Build the Project

```bash
# Build the compiler and libraries
dune build

# Build in release mode (optimized)
dune build --release
```

## Installation

Install the Thalia compiler system-wide:

```bash
dune install
```

This installs the `thalia` executable to your OPAM bin directory (typically `~/.opam/<switch>/bin/`).

## Testing

### Running Tests

```bash
# Run all tests
dune test

# Run inline tests
dune runtest
```

### Adding Tests

Inline tests are defined using `ppx_inline_test`:

```ocaml
let%test _ = Ok [] = zero
let%test _ = Ok [2] = pure 2
```

For integration tests, add test files in the `test/` directory with appropriate dune configurations.

## Usage

### Running the Compiler

```bash
# Run directly with dune
dune exec thalia

# Or if installed
thalia
```

## Contributing

Contributions are welcome. If you have a feature request, or have found a bug, feel free to open a new issue. If you wish to contribute code, see CONTRIBUTING.md for more details.

### Guidelines

1. Follow the existing code style and conventions
2. Add tests for new functionality
3. Update documentation for API changes
4. Ensure all tests pass before submitting

## License

Thalia is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version. For more details, see LICENSE file.

## Authors

**Stan Vlad** - [vstan02@protonmail.com](mailto:vstan02@protonmail.com)

