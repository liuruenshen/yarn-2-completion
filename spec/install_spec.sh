#!/usr/bin/env bash

Describe "install.sh" install
  gen_fake_time=0
  fake_time=1626813949
  date() {
    if [[ $gen_fake_time -eq 1 ]]; then
      echo "$fake_time"
    fi
  }

  cleanup() {
    rm -f "./answer.txt"
  }

  AfterAll 'cleanup'

  Parameters
    "darwin" ".bash_profile"
    "linux-gnu" ".bashrc"
  End

  It "should abort when the timestmap returned from date is empty"
    OSTYPE="$1"
    When run source "./install.sh"
    The error should equal "Failed to obtain a timestamp, abort installation."
    The status should equal 1
  End

  It "should abort when the root path of the repository is empty"
    OSTYPE="$1"
    gen_fake_time=1

    pwd() { :; }

    When run source "./install.sh"
    The error should equal "Failed to get the repository's root path where install.sh located, abort installation."
    The status should equal 1
  End

  It "should write startup code into .bashrc (default answer)"
    OSTYPE="$1"
    mkdir -p "/tmp/install1"
    HOME="/tmp/install1"
    run_test() {
      gen_fake_time=1
      echo -n $'\n'$'\n'$'\n' >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh
      exec 0<&1001
      exec 1000>&-
    }

    When call run_test
    The output should include "Install successfully."
    The contents of path "${HOME}/$2" should include "bind 'set show-all-if-unmodified on'"
    The contents of path "${HOME}/$2" should include ". /yarn-2-completion/src/completion.sh"
    The contents of path "${HOME}/$2" should include "Y2C_VERBOSE=0"
    The contents of path "${HOME}/$2" should include "Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=1"
  End

  It "should write startup code into .bashrc (disable one-tab completion)"
    OSTYPE="$1"
    mkdir -p "/tmp/install2"
    HOME="/tmp/install2"
    run_test() {
      gen_fake_time=1
      echo -n 'n'$'\n'$'\n' >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh
      exec 0<&1001
      exec 1000>&-
    }

    When call run_test
    The output should include "Install successfully."
    The contents of path "${HOME}/$2" should not include "bind 'set show-all-if-unmodified on'"
    The contents of path "${HOME}/$2" should include ". /yarn-2-completion/src/completion.sh"
    The contents of path "${HOME}/$2" should include "Y2C_VERBOSE=0"
    The contents of path "${HOME}/$2" should include "Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=1"
  End

  It "should write startup code into .bashrc (enable verbose output)"
    OSTYPE="$1"
    mkdir -p "/tmp/install3"
    HOME="/tmp/install3"
    run_test() {
      gen_fake_time=1
      echo -n $'\n'y$'\n' >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh
      exec 0<&1001
      exec 1000>&-
    }

    When call run_test
    The output should include "Install successfully."
    The contents of path "${HOME}/$2" should include "bind 'set show-all-if-unmodified on'"
    The contents of path "${HOME}/$2" should include ". /yarn-2-completion/src/completion.sh"
    The contents of path "${HOME}/$2" should include "Y2C_VERBOSE=1"
    The contents of path "${HOME}/$2" should include "Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=1"
  End

  It "should write startup code into .bashrc (disable yarn-exec completion)"
    OSTYPE="$1"
    mkdir -p "/tmp/install4"
    HOME="/tmp/install4"
    run_test() {
      gen_fake_time=1
      echo -n $'\n'$'\n'n >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh
      exec 0<&1001
      exec 1000>&-
    }

    When call run_test
    The output should include "Install successfully."
    The contents of path "${HOME}/$2" should include "bind 'set show-all-if-unmodified on'"
    The contents of path "${HOME}/$2" should include ". /yarn-2-completion/src/completion.sh"
    The contents of path "${HOME}/$2" should include "Y2C_VERBOSE=0"
    The contents of path "${HOME}/$2" should include "Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=0"
  End

  It "should write startup code into .bashrc (disable yarn-exec completion)"
    OSTYPE="$1"
    mkdir -p "/tmp/install5"
    HOME="/tmp/install5"
    run_test() {
      gen_fake_time=1
      echo -n $'\n'$'\n'n >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh
      exec 0<&1001
      exec 1000>&-
    }

    When call run_test
    The output should include "Install successfully."
    The contents of path "${HOME}/$2" should include "bind 'set show-all-if-unmodified on'"
    The contents of path "${HOME}/$2" should include ". /yarn-2-completion/src/completion.sh"
    The contents of path "${HOME}/$2" should include "Y2C_VERBOSE=0"
    The contents of path "${HOME}/$2" should include "Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=0"
  End

  It "should find out y2c has been installed"
    OSTYPE="$1"
    mkdir -p "/tmp/install6"
    HOME="/tmp/install6"
    setup() {
      gen_fake_time=1
      echo -n $'\n'$'\n'$'\n' >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh >/dev/null 2>&1
      exec 0<&1001
      exec 1000>&-
    }

    run_test() {
      . ./install.sh
    }

    setup
    When run source ./install.sh
    The output should equal "Yarn-2-completion has already been installed."
  End

  It "should back up the startup file before modifying the file"
    OSTYPE="$1"
    mkdir -p "/tmp/install7"
    HOME="/tmp/install7"

    run_test() {
      touch "${HOME}/$2"
      gen_fake_time=1
      echo -n $'\n'$'\n'$'\n' >./answer.txt
      exec 1000<>./answer.txt
      exec 1001<&0
      exec 0<&1000
      . ./install.sh
      exec 0<&1001
      exec 1000>&-
    }

    When call run_test "$@"
    The path "${HOME}/${2}.${fake_time}.bak" should be exist
    The output should include "The original ${2} has been backed up to ${HOME}/${2}.${fake_time}.bak"
  End

  It "should abort the installation when failing to backup the startup file"
    OSTYPE="$1"
    mkdir -p "/tmp/install8"
    HOME="/tmp/install8"

    cp() {
      return 1
    }

    touch "${HOME}/$2"
    gen_fake_time=1
    When run source "./install.sh" "$@"

    The path "${HOME}/${2}.${fake_time}.bak" should not be exist
    The status should equal 1
    The error should equal "Failed to backup ${HOME}/${2} to ${HOME}/${2}.${fake_time}.bak, abort installation."
  End
End
