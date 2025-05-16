# CppCompile

CppCompile is a fast, flexible command-line tool for compiling and running C++ source files with ease.

## Features

- 🛠️ Compile and auto-run C++ files
- ⚙️ Skip compile or run with flags
- 📎 Inject `#include <header>` automatically
- 💬 Print compile/run commands without executing
- 🚀 Simple install with `Setup.sh`

## Installation

```bash
gh repo clone zimoshi/cppcompile
sh setup.sh
````

> This compiles the tool and installs it to `/usr/local/bin/cppcompile`.

## Usage

```bash
cppcompile <file.cpp> [args...] [options]
```

### Options

| Flag          | Description                             |
| ------------- | --------------------------------------- |
| `-nR`         | Compile only, do not run                |
| `-nC`         | Run only, skip compilation              |
| `--include=X` | Inject `#include <X>` at the top        |
| `-pR`         | Print the compile and run commands only |

## Example

```bash
cppcompile main.cpp 1 2 3
cppcompile -nR mycode.cpp
cppcompile --include=cmath test.cpp
cppcompile -pR demo.cpp
```
