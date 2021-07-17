#!/usr/bin/env bash

Describe "list_all_files_spec.sh" list-all-files
  Include "./src/utilities/list-all-files.sh"

  It "should retrieve all the files beneath the given folder"

    When call list_all_files ./.husky
    The output should equal "./.husky/_/husky.sh"$'\n'"./.husky/pre-commit"
  End
End
