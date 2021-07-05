#!/usr/bin/env bash

Describe "src/lib.sh"
  Include "./src/lib.sh"

  is_not_bash_3() {
    [ "${BASH_VERSINFO[0]}" -ne 3 ]
  }

  is_below_bash_4() {
    [ "${BASH_VERSINFO[0]}" -lt 4 ]
  }

  Describe "y2c_detect_environment" y2c_detect_environment
    It 'should recognize if the syntax is supported(bash 3)' y2c_detect_environment:bash-3
      Skip if "bash is not version 3" "is_not_bash_3"
      When call y2c_detect_environment
      The variable IS_SUPPORT_DECLARE_N_FLAG should equal 0
      The variable IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT should equal 0
      The variable IS_SUPPORT_UPPER_CASE_TRANSFORM should equal 0
    End

    It 'should recognize if the syntax is supported(bash 4 above)' y2c_detect_environment:bash-4-above
      Skip if "bash is not version 4+" "is_below_bash_4"
      When call y2c_detect_environment
      The variable IS_SUPPORT_DECLARE_N_FLAG should equal 1
      The variable IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT should equal 1
      The variable IS_SUPPORT_UPPER_CASE_TRANSFORM should equal 1
    End
  End

  Describe "yarn_get_version_from_yarnrc" yarn_get_version_from_yarnrc
    Parameters
      "/yarn-repo/test1" "2.4.2"
      "/yarn-repo/test2" "1.22.10"
      "/yarn-repo/test3" "2.1.0"
      "/yarn-repo/test1/workspace-a" "2.4.2"
      "/yarn-repo/test3/packages/workspace-a" "2.1.0"
    End

    It 'should retrieve the expected yarn version being configured in the given repository'
      get_var_version() {
        cd "$1" || return 1
        yarn --version
      }

      When call get_var_version "$1"
      The output should equal "$2"
    End
  End

  Describe "y2c_get_var_name"
    Parameters
      "/home/test/12345/file \(111\)" "" "" "L2hvbWUvdGVzdC8xMjM0NS9maWxlIFwoMTExXCk_"
      "/tag/@12345" "PREFIX_" "" "PREFIX_L3RhZy9AMTIzNDU_"
      "sources[@]" "" 1 "L3Rlc3QvMTIzL2ZvbGRlcjEgXFthXF0_"$'\n'"L3Rlc3QvMTIzL2ZvbGRlcjEgXFtiXF0_"$'\n'"L3Rlc3QvMTIzL2ZvbGRlcjEgXFtiXF0_"
    End

    # shellcheck disable=SC2034
    sources=("/test/123/folder1 \[a\]" "/test/123/folder1 \[b\]" "/test/123/folder1 \[b\]")

    It "should return the base64-encoded string"
      When call y2c_get_var_name "$1" "$2" "$3"
      The output should equal "$4"
    End
  End

  Describe "y2c_setup"
    y2c_generate_yarn_command_list() { :; }
    y2c_generate_workspace_packages() { :; }
    y2c_generate_system_executables() { :; }

    exec_y2c_setup() {
      cd "$1" || return 1
      y2c_setup
    }

    It "should setup all the required global variables"
      y2c_detect_environment

      When call exec_y2c_setup "/yarn-repo/test3/packages/workspace-a"
      The status should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "2.1.0"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__ should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "${PWD%/packages/workspace-a}"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 1
    End
  End

End
