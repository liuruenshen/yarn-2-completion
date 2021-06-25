<h1 align="center">yarn-2-completion</h1>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)](https://img.shields.io/github/workflow/status/dustin71728/yarn-2-completion/default)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

## <a href="https://asciinema.org/a/422312" target="_blank"><img src="https://asciinema.org/a/422312.svg" /></a>

<p align="center"> Yarn 2+ BASH completion
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Getting Started](#getting_started)
- [Test](#test)

## 🧐 About <a name = "about"></a>

It is a BASH completion for yarn 2+, supporting macOS default shipped BASH version 3.2 and above.

Tested on BASH 3.2, 4.4, and 5.0 with yarn 2.1.0 and 2.4.2

## 🏁 Getting Started <a name = "getting_started"></a>

```
git clone git@github.com:dustin71728/yarn-2-completion.git

./yarn-2-completion/install.sh
```

### Prerequisites

1. Yarn version 2+
2. Node.js 8+
3. Bash 3.2+

### How it works

The installation will modify your BASH environment's startup file .bashrc(Linux) or .bash_profile(macOS) in the home directory.

BASH loads the script for yarn command's completion after opening the terminal or executing `exec $SHELL`.

Your original startup file will be saved, so if something went wrong, just recovering it from the backup file.

It also registers the setup function to PROMPT_COMMAND environment variable; whenever the command prompt gets printed, the script finds out if you are in the repository managed by yarn 2+, then prepares the configurations for accommodating your workflow with yarn commands.

## 🔧 Running the tests <a name = "tests"></a>

The repository uses [bats-core](https://github.com/bats-core/bats-core) to do testing, and [shellcheck](https://github.com/koalaman/shellcheck) to maintain coding quality.

All the tests are running in the Docker container.

```
git submodule update --init --recursive

yarn install

yarn test

# run the specified test cases
yarn test -- -f 'y2c_setup'
```
