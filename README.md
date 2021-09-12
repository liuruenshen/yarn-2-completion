<h1 align="center">yarn-2-completion</h1>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)](https://img.shields.io/github/workflow/status/liuruenshen/yarn-2-completion/default)
![Workflow](https://github.com/liuruenshen/yarn-2-completion/actions/workflows/default.yaml/badge.svg)
[![codecov](https://codecov.io/gh/liuruenshen/yarn-2-completion/branch/main/graph/badge.svg?token=JH0PRFL7MM)](https://codecov.io/gh/liuruenshen/yarn-2-completion)
[![CodeFactor](https://www.codefactor.io/repository/github/liuruenshen/yarn-2-completion/badge)](https://www.codefactor.io/repository/github/liuruenshen/yarn-2-completion)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

## <a href="https://asciinema.org/a/7ySv9iquGuNtd7572NCrWF9P9" target="_blank"><img src="https://asciinema.org/a/7ySv9iquGuNtd7572NCrWF9P9.svg" /></a>

<p align="center"> Yarn completion
    <br> 
</p>

## 📝 Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started](#getting_started)
- [About](#about)
- [Features](#features)

### Prerequisites <a name = "prerequisites"></a>

1. Yarn
2. Node.js 8+
3. Bash 3.2+

## 🏁 Getting Started <a name = "getting_started"></a>

```
git clone git@github.com:liuruenshen/yarn-2-completion.git

./yarn-2-completion/install.sh
```

## 🧐 About <a name = "about"></a>

It is a yarn completion, supporting macOS default shipped bash version 3.2 and above.

Tested on bash 3.2, 4.4, and 5.0 with yarn 1.22.10, 2.1.0 and 2.4.2

## Features <a name = "features"></a>

1. Show all the matched workspace's package names for "yarn workspace(s)" commands.

2. Prevent alternative flags from being shown again if one of them is already on the command line

   For example, -v is short flag for --version, having one on the command line disable the other one because
   they are the same.

3. List all the script names in the package.json for `yarn`, `yarn run`, `yarn workspace ...` or `yarn workspace ... run`; the package.json for which the yarn-2-completion searches depends on the command or the path where the command is typing.

4. Enable one-tab completion during installation (Optional).

5. List all the matched system executables for `yarn exec` or `yarn workspace ... exec` (Optional).

6. Show available words based on the current repository's yarn version; different repositories with different yarn versions won't interfere with each other.
