#!/usr/bin/env bash

Describe "src/lib.sh"
  Include "./src/lib.sh"
  before_each_test() {
    # shellcheck disable=SC2034
    Y2C_TESTING_MODE=1
  }

  BeforeEach "before_each_test"

  is_not_bash_3() {
    [ "${BASH_VERSINFO[0]}" -ne 3 ]
  }

  is_below_bash_4() {
    [ "${BASH_VERSINFO[0]}" -lt 4 ]
  }

  command_list_to_string() {
    local list_var_name="${1}[@]"
    local delimiter=""
    local result=""

    for command_var_name in "${!list_var_name}"; do
      command_var_name+="[@]"
      delimiter=""
      for word in "${!command_var_name}"; do
        result+="${delimiter}${word}"
        delimiter=$'\t'
      done
      result+=$'\n'
    done

    echo "$result"
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
    # shellcheck disable=SC2034
    y2c_generate_system_executables() { Y2C_GENERATE_SYSTEM_EXECUTABLES_ARGU="$1"; }

    RUN_TEST_PWD="/yarn-repo/test3"

    preserve1_stage1() {
      %preserve Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__1 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__1 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__1 \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_1 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_1 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_1
    }

    preserve1_stage2() {
      %preserve Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__2 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__2 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__2 \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_2 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_2 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_2
    }

    preserve1_stage3() {
      %preserve Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__3 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__3 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__3 \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_3 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_3 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_3
    }

    run_y2c_setup_test1() {
      y2c_detect_environment

      cd "/yarn-repo/test3/packages/workspace-a" || return 1
      y2c_setup
      #shellcheck disable=SC2034
      STATUS_1=$?
      preserve1_stage1

      cd "../../" || return 1
      y2c_setup
      #shellcheck disable=SC2034
      STATUS_2=$?
      preserve1_stage2

      cd "packages/workspace-a" || return 1
      y2c_setup
      #shellcheck disable=SC2034
      STATUS_3=$?
      preserve1_stage3
    }

    It "should setup all the required global variables (single repository)"
      When call run_y2c_setup_test1
      The variable Y2C_GENERATE_SYSTEM_EXECUTABLES_ARGU should equal "${PATH}"
      The variable STATUS_1 should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__1 should equal '2.1.0'
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__1 should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__1 should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH_1 should equal "${RUN_TEST_PWD}"
      The variable Y2C_IS_YARN_2_REPO_1 should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_1 should equal 1

      The variable STATUS_2 should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__2 should equal '2.1.0'
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__2 should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__2 should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH_2 should equal "${RUN_TEST_PWD}"
      The variable Y2C_IS_YARN_2_REPO_2 should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_2 should equal 0

      The variable STATUS_3 should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__3 should equal '2.1.0'
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__3 should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__3 should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH_3 should equal "${RUN_TEST_PWD}"
      The variable Y2C_IS_YARN_2_REPO_3 should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_3 should equal 1
    End

    preserve2_stage1() {
      %preserve Y2C_SETUP_HIT_CACHE:Y2C_SETUP_HIT_CACHE_1 \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__1 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__1 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__1 \
        \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_1 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_1 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_1
    }

    preserve2_stage2() {
      %preserve Y2C_SETUP_HIT_CACHE:Y2C_SETUP_HIT_CACHE_2 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__2 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__2 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__2 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__2 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__2 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__2 \
        \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_2 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_2 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_2
    }

    preserve2_stage3() {
      %preserve Y2C_SETUP_HIT_CACHE:Y2C_SETUP_HIT_CACHE_3 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__3 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__3 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__3 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__3 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__3 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__3 \
        \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_3 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_3 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_3
    }

    preserve2_stage4() {
      %preserve Y2C_SETUP_HIT_CACHE:Y2C_SETUP_HIT_CACHE_4 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__4 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__4 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__4 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__4 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__4 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__4 \
        \
        Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__4 \
        Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__4 \
        Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__:Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__4 \
        \
        Y2C_CURRENT_ROOT_REPO_PATH:Y2C_CURRENT_ROOT_REPO_PATH_4 \
        Y2C_IS_YARN_2_REPO:Y2C_IS_YARN_2_REPO_4 \
        Y2C_IS_IN_WORKSPACE_PACKAGE:Y2C_IS_IN_WORKSPACE_PACKAGE_4
    }

    run_y2c_setup_test2() {
      y2c_detect_environment

      cd /yarn-repo/test1 || return 1
      y2c_setup
      preserve2_stage1

      cd ../test2 || return 1
      y2c_setup
      preserve2_stage2

      cd ../test1/workspace-b || return 1
      y2c_setup
      preserve2_stage3

      cd ../../test3/packages/workspace-a || return 1
      y2c_setup
      preserve2_stage4
    }

    It "should setup all the required global variables (across repositories)"
      When call run_y2c_setup_test2
      The variable Y2C_GENERATE_SYSTEM_EXECUTABLES_ARGU should equal "${PATH}"

      The variable Y2C_SETUP_HIT_CACHE_1 should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__1 should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__1 should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__1 should equal 1

      The variable Y2C_CURRENT_ROOT_REPO_PATH_1 should equal "/yarn-repo/test1"
      The variable Y2C_IS_YARN_2_REPO_1 should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_1 should equal 0

      The variable Y2C_SETUP_HIT_CACHE_2 should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__2 should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__2 should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__2 should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__2 should equal "1.22.10"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__2 should equal "MS4yMi4xMA__"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__2 should equal 0

      The variable Y2C_CURRENT_ROOT_REPO_PATH_2 should equal "/yarn-repo/test2"
      The variable Y2C_IS_YARN_2_REPO_2 should equal 0
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_2 should equal 0

      The variable Y2C_SETUP_HIT_CACHE_3 should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__3 should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__3 should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__3 should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__3 should equal "1.22.10"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__3 should equal "MS4yMi4xMA__"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__3 should equal 0

      The variable Y2C_CURRENT_ROOT_REPO_PATH_3 should equal "/yarn-repo/test1"
      The variable Y2C_IS_YARN_2_REPO_3 should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_3 should equal 1

      The variable Y2C_SETUP_HIT_CACHE_4 should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__4 should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__4 should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__4 should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__4 should equal "1.22.10"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__4 should equal "MS4yMi4xMA__"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__4 should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__4 should equal "2.1.0"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__4 should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__4 should equal 1

      The variable Y2C_CURRENT_ROOT_REPO_PATH_4 should equal "/yarn-repo/test3"
      The variable Y2C_IS_YARN_2_REPO_4 should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE_4 should equal 1
    End
  End

  Describe "y2c_generate_yarn_command_list"
    y2c_expand_yarn_workspace_command_list_argu=""

    y2c_expand_yarn_workspace_command_list() {
      # shellcheck disable=2034
      y2c_expand_yarn_workspace_command_list_argu="$1 $2"
    }

    Parameters
      "/yarn-repo/test1" "Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_" "Y2C_COMMAND_TOKENS_Mi40LjI__42 Y2C_COMMAND_TOKENS_LIST_VER_Mi40LjI_"
      "/yarn-repo/test3" "Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_" "Y2C_COMMAND_TOKENS_Mi4xLjA__34 Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_"
    End

    matched_commands=""
    run_test() {
      cd "$1" || return 1
      y2c_detect_environment

      Y2C_YARN_VERSION=$(y2c_is_yarn_2)
      # shellcheck disable=2034
      Y2C_YARN_BASE64_VERSION=$(y2c_get_var_name "${Y2C_YARN_VERSION}")
      y2c_generate_yarn_command_list

      matched_commands=$(generate_yarn_expected_command_list "${Y2C_YARN_VERSION}")
      command_list_to_string "$2"
    }

    It "should create the command list"
      When call run_test "$1" "$2"
      The output should equal "$matched_commands"
      The variable y2c_expand_yarn_workspace_command_list_argu should equal "$3"
    End
  End

  Describe "y2c_set_package_name_path_map"
    # shellcheck disable=2034
    Y2C_CURRENT_ROOT_REPO_BASE64_PATH="FAKEBASE64"
    package_names=()
    package_paths=()

    Parameters
      "workspace-a workspace-b" "/yarn-repo/packages/workspace-a /yarn-repo/packages/workspace-b" \
        "Y2C_PACKAGE_NAME_PATH_FAKEBASE64_d29ya3NwYWNlLWE_ Y2C_PACKAGE_NAME_PATH_FAKEBASE64_d29ya3NwYWNlLWI_"
      "@package1" "/yarn-repo/packages/package-1" \
        "Y2C_PACKAGE_NAME_PATH_FAKEBASE64_QHBhY2thZ2Ux"
    End

    run_test() {
      y2c_detect_environment
      # shellcheck disable=2034
      read -r -a package_names <<<"$1"
      # shellcheck disable=2034
      read -r -a package_paths <<<"$2"

      y2c_set_package_name_path_map "package_names[@]" "package_paths[@]"
    }

    It "should create the global variable containing the path to the workspace"
      When call run_test "$1" "$2"
      read -r -a var_names <<<"$3"
      for index in "${!var_names[@]}"; do
        The variable "${var_names[$index]}" should equal "${package_paths[$index]}"
      done
    End
  End
End
