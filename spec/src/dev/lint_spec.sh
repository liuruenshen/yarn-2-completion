#!/usr/bin/env bash
Describe "Running test cases on src/dev/lint.sh" "lint"
  It "should abort the link process if the docker is not found"
    When run script "./src/dev/lint.sh"
    The output should be blank
    The error should equal "Install docker before committing any changes"
  End

  cleanup() {
    rm -f /tmp/shellcheck_has_been_pulled
    rm -f /tmp/checked_files
  }

  find_files_in_src_folder() {
    find ./src -type f | while read -r; do echo "${REPLY/*src/}"; done | sort
  }

  AfterEach "cleanup"

  It "should pull shellcheck image"
    command() {
      return 0
    }

    docker() {
      checked_files=""
      case "$*" in
      'images'*) echo "" ;;
      'pull koalaman/shellcheck')
        touch /tmp/shellcheck_has_been_pulled
        ;;
      'run'*)
        while [[ -n $1 ]]; do
          if [[ $1 = '"/checking_files"'* ]]; then
            checked_files+="${1/\"\/checking_files\"/}"$'\n'
          elif [[ $1 = '/checking_files'* ]]; then
            checked_files+="${1/\/checking_files/}"$'\n'
          fi
          shift 1
        done

        echo -n "$checked_files" | sort >/tmp/checked_files
        ;;
      esac
    }

    When run source "./src/dev/lint.sh"
    The file /tmp/shellcheck_has_been_pulled should be exist
    The contents of file /tmp/checked_files should equal "$(find_files_in_src_folder)"
  End
End
