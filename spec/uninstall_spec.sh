#!/usr/bin/env bash

Describe "testing unisntall process" uninstall
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

  Describe "aborting uninstall.sh"
    Parameters
      "darwin" ".bash_profile"
      "linux-gnu" ".bashrc"
    End

    It "should abort when the timestmap returned from date is empty"
      OSTYPE="$1"
      When run source "./uninstall.sh"
      The error should equal "Failed to get the timestamp, abort."
      The status should equal 1
    End

    It "should abort when the failed to get the repository's root path"
      OSTYPE="$1"
      gen_fake_time=1

      pwd() { :; }

      When run source "./uninstall.sh"
      The error should equal "Failed to get the repository's root path where uninstall.sh is located, abort."
      The status should equal 1
    End

    It "should abort if the startup file is not found"
      OSTYPE="$1"
      gen_fake_time=1
      HOME="/tmp/uninstall_test1"

      mkdir -p "${HOME}"

      When run source "./uninstall.sh"
      The output should equal "${HOME}/${2} is not found, abort."
      The status should equal 0
    End

    It "should find out that y2c hasn't been installed"
      OSTYPE="$1"
      gen_fake_time=1
      HOME="/tmp/uninstall_test2"

      mkdir -p "${HOME}"

      echo "export data=1"$'\n' >"${HOME}/${2}"

      When run source "./uninstall.sh"
      The output should equal "Yarn-2-completion has already been uninstalled."
      The status should equal 0
    End
  End

  Describe "test uninstall.sh with install.sh"
    Parameters
      "darwin" ".bash_profile" $'\n'$'\n'$'\n'
      "darwin" ".bash_profile" 'n'$'\n'$'\n'
      "darwin" ".bash_profile" $'\n''y'$'\n'
      "darwin" ".bash_profile" $'\n'$'\n''n'
      "linux-gnu" ".bashrc" $'\n'$'\n'$'\n'
      "linux-gnu" ".bashrc" 'n'$'\n'$'\n'
      "linux-gnu" ".bashrc" $'\n''y'$'\n'
      "linux-gnu" ".bashrc" $'\n'$'\n''n'
    End

    It "should clear all the instructions the installation put into the startup file(no existing startup file)"
      OSTYPE="$1"
      HOME="/tmp/uninstall_test3"
      mkdir -p "${HOME}"

      installed_content=""

      run_test() {
        gen_fake_time=1
        echo -n "$3" >./answer.txt
        exec 1000<>./answer.txt
        exec 1001<&0
        exec 0<&1000
        #shellcheck disable=SC1091
        . ./install.sh
        exec 0<&1001
        exec 1000>&-
        installed_content=$(cat "${HOME}/$2")
        #shellcheck disable=SC1091
        . ./uninstall.sh
      }

      When call run_test "$@"

      The path "${HOME}/${2}.${fake_time}.bak" should be exist
      The path "${HOME}/${2}" should be exist

      The contents of path "${HOME}/${2}.${fake_time}.bak" should equal "${installed_content}"
      The contents of path "${HOME}/${2}" should equal ""

      The output should include "Uninstall successfully. The original ${HOME}/${2} file has been backuped to ${HOME}/${2}.${fake_time}.bak"
    End

    It "should clear all the instructions the installation put into the startup file(existing startup file)"
      OSTYPE="$1"
      HOME="/tmp/uninstall_test4"
      mkdir -p "${HOME}"

      installed_content=""
      existing_content="export data=1"$'\n'"export data2=y"$'\n'

      run_test() {
        echo -n "${existing_content}" >"${HOME}/${2}"
        gen_fake_time=1
        echo -n "$3" >./answer.txt
        exec 1000<>./answer.txt
        exec 1001<&0
        exec 0<&1000
        #shellcheck disable=SC1091
        . ./install.sh
        exec 0<&1001
        exec 1000>&-
        installed_content=$(cat "${HOME}/$2")
        #shellcheck disable=SC1091
        . ./uninstall.sh
      }

      When call run_test "$@"

      The path "${HOME}/${2}.${fake_time}.bak" should be exist
      The path "${HOME}/${2}" should be exist

      The contents of path "${HOME}/${2}.${fake_time}.bak" should equal "${installed_content}"
      The contents of path "${HOME}/${2}" should equal "${existing_content%$'\n'}"

      The output should include "Uninstall successfully. The original ${HOME}/${2} file has been backuped to ${HOME}/${2}.${fake_time}.bak"
    End

  End
End
