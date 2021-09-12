#!/usr/bin/env bash

Describe "list_all_files_spec.sh" list-all-files
  Include "./src/utilities/list-all-files.sh"

  It "should list all the files beneath the given folder"

    When call list_all_files ./.husky
    The output should equal "./.husky/_/husky.sh"$'\n'"./.husky/pre-commit"
  End

  It "should list all the files beneath the given folder"

    When call list_all_files ./.husky "*.sh"
    The output should equal "./.husky/_/husky.sh"
  End
End
