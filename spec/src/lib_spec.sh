#!/usr/bin/env bash

Describe "src/lib.sh"
  Include "./src/lib.sh"

  preserve_global_y2c_var() {
    local file="$1"
    local grep_prefix="${2:-Y2C}"
    set | grep -E '^'"${grep_prefix}"'[[:alnum:]_]*=' >"${file}"
  }

  before_each_test() {
    # shellcheck disable=SC2034
    Y2C_TESTING_MODE=1
  }

  BeforeEach "before_each_test"

  is_not_bash_3() {
    [[ ${BASH_VERSINFO[0]} -ne 3 ]]
  }

  is_below_bash_4() {
    [[ ${BASH_VERSINFO[0]} -lt 4 ]]
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

  commands_to_command_list() {
    local content="$1"
    local tokens_var_name_prefix="$2"
    local command_line=""
    local tokens=()

    declare -i index=${#command_list[@]}

    { while read -r command_line; do
      #shellcheck disable=SC2034
      IFS=$'\t' read -r -a tokens <<<"$command_line"
      eval "${tokens_var_name_prefix}${index}=(\"\${tokens[@]}\")"
      command_list+=("${tokens_var_name_prefix}${index}")
      index+=1
    done; } <<<"$content"
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
    declaration_file_prefix="/tmp/y2c_setup_preserve_"
    y2c_generate_yarn_command_list() { :; }
    y2c_generate_workspace_packages() { :; }
    # shellcheck disable=SC2034
    y2c_generate_system_executables() { Y2C_GENERATE_SYSTEM_EXECUTABLES_ARGU="$1"; }

    RUN_TEST_PWD="/yarn-repo/test3"

    run_y2c_setup_test1() {
      y2c_detect_environment

      cd "/yarn-repo/test3/packages/workspace-a" || return 1
      y2c_setup
      #shellcheck disable=SC2034
      STATUS_1=$?
      preserve_global_y2c_var "${declaration_file_prefix}1$$"

      cd "../../" || return 1
      y2c_setup
      #shellcheck disable=SC2034
      STATUS_2=$?
      preserve_global_y2c_var "${declaration_file_prefix}2$$"

      cd "packages/workspace-a" || return 1
      y2c_setup
      #shellcheck disable=SC2034
      STATUS_3=$?
      preserve_global_y2c_var "${declaration_file_prefix}3$$"
    }

    It "should set up all the required global variables in a single repository"
      When call run_y2c_setup_test1
      #shellcheck disable=SC1090
      source "${declaration_file_prefix}1$$"
      The variable Y2C_GENERATE_SYSTEM_EXECUTABLES_ARGU should equal "${PATH}"
      The variable STATUS_1 should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal '2.1.0'
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__ should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "${RUN_TEST_PWD}"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 1

      #shellcheck disable=SC1090
      source "${declaration_file_prefix}2$$"
      The variable STATUS_2 should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal '2.1.0'
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__ should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "${RUN_TEST_PWD}"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 0

      #shellcheck disable=SC1090
      source "${declaration_file_prefix}3$$"
      The variable STATUS_3 should equal 0
      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal '2.1.0'
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__ should equal 1
      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "${RUN_TEST_PWD}"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 1
    End

    run_y2c_setup_test2() {
      y2c_detect_environment

      cd /yarn-repo/test1 || return 1
      y2c_setup
      preserve_global_y2c_var "${declaration_file_prefix}4$$"

      cd ../test2 || return 1
      y2c_setup
      preserve_global_y2c_var "${declaration_file_prefix}5$$"

      cd ../test1/workspace-b || return 1
      y2c_setup
      preserve_global_y2c_var "${declaration_file_prefix}6$$"

      cd ../../test3/packages/workspace-a || return 1
      y2c_setup
      preserve_global_y2c_var "${declaration_file_prefix}7$$"
    }

    It "should set up all the required global variables across repositories"
      When call run_y2c_setup_test2
      #shellcheck disable=SC1090
      source "${declaration_file_prefix}4$$"

      The variable Y2C_GENERATE_SYSTEM_EXECUTABLES_ARGU should equal "${PATH}"
      The variable Y2C_SETUP_HIT_CACHE should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__ should equal 1

      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "/yarn-repo/test1"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 0

      #shellcheck disable=SC1090
      source "${declaration_file_prefix}5$$"
      The variable Y2C_SETUP_HIT_CACHE should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__ should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__ should equal "1.22.10"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__ should equal "MS4yMi4xMA__"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__ should equal 0

      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "/yarn-repo/test2"
      The variable Y2C_IS_YARN_2_REPO should equal 0
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 0

      #shellcheck disable=SC1090
      source "${declaration_file_prefix}6$$"
      The variable Y2C_SETUP_HIT_CACHE should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__ should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__ should equal "1.22.10"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__ should equal "MS4yMi4xMA__"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__ should equal 0

      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "/yarn-repo/test1"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 1

      #shellcheck disable=SC1090
      source "${declaration_file_prefix}7$$"
      The variable Y2C_SETUP_HIT_CACHE should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "2.4.2"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0MQ__ should equal "Mi40LjI_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0MQ__ should equal 1

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mg__ should equal "1.22.10"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mg__ should equal "MS4yMi4xMA__"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mg__ should equal 0

      The variable Y2C_REPO_YARN_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "2.1.0"
      The variable Y2C_REPO_YARN_BASE64_VERSION_L3lhcm4tcmVwby90ZXN0Mw__ should equal "Mi4xLjA_"
      The variable Y2C_REPO_IS_YARN_2_L3lhcm4tcmVwby90ZXN0Mw__ should equal 1

      The variable Y2C_CURRENT_ROOT_REPO_PATH should equal "/yarn-repo/test3"
      The variable Y2C_IS_YARN_2_REPO should equal 1
      The variable Y2C_IS_IN_WORKSPACE_PACKAGE should equal 1
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
      "/yarn-repo/test2" "Y2C_COMMAND_TOKENS_LIST_VER_MS4yMi4xMA__" "Y2C_COMMAND_TOKENS_MS4yMi4xMA___77 Y2C_COMMAND_TOKENS_LIST_VER_MS4yMi4xMA__"
      "/yarn-repo/test3" "Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_" "Y2C_COMMAND_TOKENS_Mi4xLjA__34 Y2C_COMMAND_TOKENS_LIST_VER_Mi4xLjA_"
    End

    run_test() {
      matched_commands=""

      cd "$1" || return 1
      y2c_detect_environment

      Y2C_YARN_VERSION=$(y2c_is_yarn_2)
      Y2C_IS_YARN_2_REPO=$(($? ^ 1))
      # shellcheck disable=2034
      Y2C_YARN_BASE64_VERSION=$(y2c_get_var_name "${Y2C_YARN_VERSION}")
      y2c_generate_yarn_command_list

      matched_commands=$(generate_yarn_expected_command_list "${Y2C_YARN_VERSION}")
      command_list_to_string "$2"
    }

    It "should create a list of commands"
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

    It "should create the global variable being assigned a path to the package in the workspace"
      When call run_test "$1" "$2"
      read -r -a var_names <<<"$3"
      for index in "${!var_names[@]}"; do
        The variable "${var_names[$index]}" should equal "${package_paths[$index]}"
      done
    End
  End

  Describe "y2c_generate_workspace_packages"
    package_names_argu_num=0
    package_paths_argu_num=0

    y2c_set_package_name_path_map() {
      local package_names=("${!1}")
      local package_paths=("${!2}")

      package_names_argu_num=${#package_names[@]}
      package_paths_argu_num=${#package_paths[@]}
    }

    Parameters
      "/yarn-repo/test1" "Y2C_WORKSPACE_PACKAGES_L3lhcm4tcmVwby90ZXN0MQ__" "wrk-a wrk-b wrk-c"
      "/yarn-repo/test3" "Y2C_WORKSPACE_PACKAGES_L3lhcm4tcmVwby90ZXN0Mw__" "wrk-a wrk-b wrk-c"
    End

    run_test() {
      # shellcheck disable=2034
      package_names_argu_num=0
      package_paths_argu_num=0

      y2c_detect_environment
      cd "$1" || return 1

      Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
      # shellcheck disable=2034
      Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
      y2c_generate_workspace_packages
    }

    It "should create the base64-encoded-repository-path variable, and the value is the list of names of all the workspace's packages."
      When call run_test "$1" "$2"
      The variable package_names_argu_num should equal "$package_paths_argu_num"
      The variable "$2[*]" should equal "$3"
    End
  End

  Describe "y2c_get_identified_token"
    Parameters
      "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached" \
        "$Y2C_YARN_WORD_IS_OPTION"
      "add" "$Y2C_YARN_WORD_IS_ORDER"
      "<commandName" "$Y2C_YARN_WORD_IS_VARIABLE"
    End

    run_test() {
      y2c_get_identified_token "$1"
    }

    It "should classify the passed argument"
      an_array() {
        local declaration
        # shellcheck disable=SC2154 disable=SC2034
        declaration=$(declare -p Y2C_TMP_IDENTIFIED_TOKENS)
        The variable declaration should start with "declare -a"
      }

      the_expected_value() {
        # shellcheck disable=SC2154
        local input="$1"
        local token_type="$2"
        local result
        local delimiter

        if [[ $token_type -eq $Y2C_YARN_WORD_IS_OPTION ]]; then
          result=""
          for word in "${Y2C_TMP_IDENTIFIED_TOKENS[@]}"; do
            result+="${delimiter}${word}"
            delimiter=","
          done
          input=${input#[}
        else
          result="${Y2C_TMP_IDENTIFIED_TOKENS[*]}"
        fi

        The variable result should equal "$input"
      }

      When call run_test "$1"
      The status should equal "$2"
      an_array
      the_expected_value "$1" "$2"
    End
  End

  Describe "y2c_expand_workspaceName_variable"
    y2c_set_package_name_path_map() {
      :
    }

    Parameters
      /yarn-repo/test1 "Y2C_WORKSPACE_PACKAGES_L3lhcm4tcmVwby90ZXN0MQ__[*]"
      /yarn-repo/test3 "Y2C_WORKSPACE_PACKAGES_L3lhcm4tcmVwby90ZXN0Mw__[*]"
    End

    run_test() {
      cd "$1" || return 1

      y2c_detect_environment

      Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
      # shellcheck disable=2034
      Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
      y2c_generate_workspace_packages
      y2c_expand_workspaceName_variable
    }

    It "should expand workspaceName to a list of package names"
      When call run_test "$1"

      The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should equal "${!2}"
    End
  End

  Describe "y2c_set_expand_var"
    y2c_set_package_name_path_map() {
      :
    }

    Parameters
      /yarn-repo/test1 "<workspaceName" "Y2C_WORKSPACE_PACKAGES_L3lhcm4tcmVwby90ZXN0MQ__[*]"
      /yarn-repo/test1 "tag" ""
      /yarn-repo/test1 "<tag" ""
      /yarn-repo/test3 "<workspaceName" "Y2C_WORKSPACE_PACKAGES_L3lhcm4tcmVwby90ZXN0Mw__[*]"
    End

    run_test() {
      cd "$1" || return 1

      y2c_detect_environment

      Y2C_CURRENT_ROOT_REPO_PATH="${PWD}"
      # shellcheck disable=2034
      Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
      y2c_generate_workspace_packages
      y2c_set_expand_var "$2"
    }

    It "should set up the global variable by the name of Y2C_TMP_EXPANDED_VAR_RESULT"
      validate_y2c_tmp_expanded_var_result() {
        # shellcheck disable=SC2154
        local token="$1"
        local global_var="$2"

        if [[ -z $global_var ]]; then
          token="${token#<}"
          The value ${#Y2C_TMP_EXPANDED_VAR_RESULT[@]} should equal 1
          The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should equal "${token}"
        else
          The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should equal "${!global_var}"
        fi
      }

      When call run_test "$1" "$2"
      validate_y2c_tmp_expanded_var_result "$2" "$3"
    End
  End

  Describe "y2c_expand_yarn_workspace_command_list"
    Parameters
      "2.4.2" "validated_command_" "validated_command_41" "validated_command_42"
      "2.1.0" "validated_command_" "validated_command_34"
    End

    run_test() {
      y2c_detect_environment
      local content=""
      local command_list=()
      local version="$1"
      local tokens_var_name="$2"
      local reference_command=""

      shift 2

      expected_command_part1=$(generate_yarn_expected_command_list "$version")
      expected_command_part2=$(generate_expected_workspace_commands "$version")

      commands_to_command_list "$expected_command_part1" "$tokens_var_name"

      for reference_command in "$@"; do
        y2c_expand_yarn_workspace_command_list "${reference_command}" "command_list"
      done

      command_list_to_string "command_list"
    }

    It "should generate the a list of commands matching the snapshot"
      expected_command_part1=""
      expected_command_part2=""

      When call run_test "$@"
      The output should equal "${expected_command_part1}"$'\n'"${expected_command_part2}"
    End
  End

  Describe "y2c_set_alternative_options"
    Parameters
      "-D|--dev" "-D" "--dev"
      "-f|--fields #0" "-f" "--fields #0"
    End

    run_test() {
      y2c_set_alternative_options "$1"

      for token in "${Y2C_TMP_ALTERNATIVE_OPTIONS[@]}"; do
        echo "${token}"
      done
    }

    It "should divide up the string into the list of alternative options"
      When call run_test "$1"
      shift
      for ((index = 1; index <= $#; ++index)); do
        The line "$index" of output should equal "${!index}"
      done
    End
  End

  Describe "y2c_add_word_to_comreply"
    Parameters
      "yarn,add,--json" \
        "--json --" \
        ""
      "yarn,add,--json" \
        "--interactive --" \
        "--interactive"
      "yarn,config,g" \
        "add g" \
        "get g" \
        "get g" \
        "gets g" \
        "set g" \
        "get get gets"
      "yarn,workspace,@test,add,-i,--json,," \
        "workspace " \
        "--interactive " \
        "-i " \
        "--json " \
        "--interactive"
      "yarn,workspace,@test,add,--json,--" \
        "-D --" \
        "--dev --" \
        "-O --" \
        "--option --" \
        "--dev --option"
      "yarn,workspace,@test,add,--interactive,-" \
        "-D -" \
        "--dev -" \
        "-O -" \
        "--option -" \
        "-i -" \
        "-D --dev -O --option -i"
    End

    run_test() {
      IFS="," read -r -a COMP_WORDS <<<"$1"
      shift

      COMPREPLY=()
      while [ $# -gt 1 ]; do
        read -r -a input_list <<<"$1"
        y2c_add_word_to_comreply "${input_list[@]}"
        shift
      done

      echo "${COMPREPLY[*]}"
    }

    It "should follow the spec adding the word to COMREPLY"
      expected_output_var_name="$#"
      When call run_test "$@"
      The output should equal "${!expected_output_var_name}"
    End
  End

  Describe "y2c_add_word_candidates (order)" y2c_add_word_candidates:order
    y2c_add_word_to_comreply() {
      result_list+=("$1" "$2")
    }

    y2c_set_expand_var() {
      # shellcheck disable=2034
      Y2C_TMP_EXPANDED_VAR_RESULT=("@test1" "@test2" "@test3")
    }

    Parameters
      "yarn,a" "add a" "add a"
      "yarn,workspace,@" "<workspaceName @" "@test1 @ @test2 @ @test3 @"
    End

    run_test() {
      y2c_detect_environment

      local result_list=()
      COMP_WORDS=()
      IFS="," read -r -a COMP_WORDS <<<"$1"
      read -r -a arguments <<<"$2"
      y2c_add_word_candidates "${arguments[@]}"

      echo "${result_list[*]}"
    }

    It "should call y2c_add_word_to_comreply with the expected arguments"
      When call run_test "$1" "$2"
      The output should equal "$3"
    End
  End

  Describe "y2c_add_word_candidates (options)" y2c_add_word_candidates:options
    y2c_add_word_to_comreply() {
      :
    }

    Parameters
      "yarn,add,," \
        "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached " \
        "--json -E --exact -T --tilde -C --caret -D --dev -P --peer -O --optional --prefer-dev -i --interactive --cached"
      "yarn,add,--" \
        "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached --" \
        "--json --exact --tilde --caret --dev --peer --optional --prefer-dev --interactive --cached"
      "yarn,add,-E,--tilde,--dev,-" \
        "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached -" \
        "--json -C --caret -P --peer -O --optional --prefer-dev -i --interactive --cached"
      "yarn,add,--json,--dev,-T,--caret,--optional,--prefer-dev,-i,--" \
        "[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached --" \
        "--exact --peer --cached"
      "yarn,run,--inspect-brk,-" \
        "[--inspect-brk,--inspect -" \
        "--inspect"
    End

    run_test() {
      y2c_detect_environment

      COMPREPLY=()
      COMP_WORDS=()
      IFS="," read -r -a COMP_WORDS <<<"$1"
      read -r -a arguments <<<"$2"
      y2c_add_word_candidates "${arguments[@]}"

      echo "${COMPREPLY[*]}"
    }

    It "should assign available words to COMPREPLY"
      When call run_test "$1" "$2"
      The output should equal "$3"
    End
  End

  Describe "y2c_add_word_candidates ( option with #[number] )" y2c_add_word_candidates:options_with_hash
    y2c_add_word_to_comreply() {
      :
    }

    y2c_set_expand_var() {
      # shellcheck disable=2034
      Y2C_TMP_EXPANDED_VAR_RESULT=("@test1" "@test2" "@test3")
    }

    Parameters
      "yarn,plugin,import,from,sources,--path,test,," \
        "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force"$'\t'"-" \
        "--repository #0 --branch #0 --no-minify -f --force"
      "yarn,plugin,import,from,sources,--path,test,--repository,test2,-" \
        "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force"$'\t'"-" \
        "--branch #0 --no-minify -f --force"
      "yarn,plugin,import,from,sources,--path,test,--repository,test2,-f,," \
        "[--path #0,--repository #0,--branch #0,--no-minify,-f|--force"$'\t'"" \
        "--branch #0 --no-minify"
    End

    run_test() {
      y2c_detect_environment

      COMPREPLY=()
      COMP_WORDS=()
      IFS="," read -r -a COMP_WORDS <<<"$1"
      IFS=$'\t' read -r -a arguments <<<"$2"
      y2c_add_word_candidates "${arguments[@]}"

      echo "${COMPREPLY[*]}"
    }

    It "should assign available words to COMPREPLY"
      When call run_test "$1" "$2"
      The output should equal "$3"
    End
  End

  Describe "y2c_is_commandline_word_match_option"
    Parameters
      "yarn,npm,logout,-s,," "-s" "-s|--scope #0" 3 "${Y2C_COMMAND_WORDS_MATCH_OPTION}" 0 blank
      "yarn,npm,logout,--scope,," "--scope" "-s|--scope #0" 3 "${Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION}" 1 "#0"
      "yarn,npm,logout,--option,test,," "--option" "-o|--option #0 #1" 3 "${Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION}" 2 "#1"
      "yarn,npm,logout,--invalid,," "--invalid" "--branch #0" 3 "${Y2C_COMMAND_WORDS_NOT_MATCH_OPTION}" 0 blank
      "yarn,audit,--level,," "--level" "--level critical|--level high|--level low" 2 "${Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION}" 1 "critical high low"
      "yarn,audit,--level,c," "--level" "--level critical|--level high|--level low" 2 "${Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION}" 1 "critical"
      "yarn,audit,--level,high," "--level" "--level critical|--level high|--level low" 2 "${Y2C_COMMAND_WORDS_MATCH_OPTION}" 1 blank
    End

    run_test() {
      y2c_detect_environment

      COMPREPLY=()
      COMP_WORDS=()
      IFS="," read -r -a COMP_WORDS <<<"$1"
      y2c_is_commandline_word_match_option "$2" "$3" "$4"
    }

    It "should find the matched option and fill out the missing part"
      validate_y2c_is_commandline_word_match_option() {
        The status should equal "$1"
        The variable Y2C_TMP_OPTION_BOUNDARY_OFFSET should equal "$2"
        if [[ $3 = blank ]]; then
          The variable "COMPREPLY[*]" should be blank
        else
          The variable "COMPREPLY[*]" should equal "$3"
        fi
      }

      When call run_test "$1" "$2" "$3" "$4"
      validate_y2c_is_commandline_word_match_option "$5" "$6" "$7"
    End
  End

  Describe "y2c_run_yarn_completion" y2c_run_yarn_completion
    declaration_file_prefix="/tmp/_preserve_"

    y2c_set_expand_var() {
      :
    }

    y2c_set_expand_var() {
      :
    }

    command_list=()

    run_test() {
      local type="$1"
      local result=""
      local y2c_command_list_var_name="Y2C_COMMAND_TOKENS_LIST_VER_$3"
      local declaration_file="${declaration_file_prefix}$2"

      y2c_add_word_candidates() {
        result+="[$1;$2]"
      }

      case "$type" in
      setup)
        [[ -f "$declaration_file" ]] && return 0

        command_list=()
        commands_to_command_list "$(generate_yarn_expected_command_list "$2")" "Y2C_MATCHED_COMMAND_"
        commands_to_command_list "$(generate_expected_workspace_commands "$2")" "Y2C_MATCHED_COMMAND_"
        eval "${y2c_command_list_var_name}=(\"\${command_list[@]}\")"
        #shellcheck disable=SC2034
        Y2C_YARN_BASE64_VERSION="$3"
        preserve_global_y2c_var "${declaration_file}"
        ;;
      example)
        # shellcheck disable=SC1090
        source "${declaration_file}"
        [[ $(type -t run_test_override_variables) = "function" ]] && run_test_override_variables "$@"
        y2c_detect_environment
        IFS="," read -r -a COMP_WORDS <<<"$3"
        y2c_run_yarn_completion "${COMP_WORDS[${#COMP_WORDS[@]} - 1]}"
        if [[ -n "$result" ]]; then
          echo "$result"
        else
          echo "${COMPREPLY[*]}"
        fi
        ;;
      esac
    }

    the_spec() {
      local type="$1"
      if [[ $type = "setup" ]]; then
        return 0
      fi

      [[ $the_spec = "$4" ]]
    }

    Describe "y2c_run_yarn_completion(standard)"
      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,config,," "[[-v|--verbose,--why,--json;][get;][set;]"
        "example" "2.4.2" "yarn,add,--json,-D,--optional,--" "[[--json,-E|--exact,-T|--tilde,-C|--caret,-D|--dev,-P|--peer,-O|--optional,--prefer-dev,-i|--interactive,--cached;--][...;--]"
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.1.0" "yarn,cache,clean,," "[[--mirror,--all;]"
        "example" "2.1.0" "yarn,remove,--" "[[-A|--all;--][...;--]"
      End

      It "should assign available words to COMPREPLY"
        When call run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End

    Describe "y2c_run_yarn_completion(workspace command)"
      run_test_override_variables() {
        #shellcheck disable=SC2034
        Y2C_TMP_EXPANDED_VAR_RESULT=("@test")
      }

      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,workspace,@test,," "[<commandName;][add;][bin;][cache;][config;][dedupe;][dlx;][exec;][explain;][info;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][<scriptName;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,i" "[import;i][list;i][remove;i][runtime;i]"
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.1.0" "yarn,workspace,@test,," "[<commandName;][add;][bin;][cache;][config;][dlx;][exec;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][<scriptName;]"
        "example" "2.1.0" "yarn,workspace,@test,plugin,i" "[import;i][list;i][remove;i][runtime;i]"
      End

      It "should assign available words to COMPREPLY"
        When call run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End

    Describe "y2c_run_yarn_completion(Y2C_IS_IN_WORKSPACE_PACKAGE)"
      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,," \
          "[add;][bin;][cache;][config;][dedupe;][dlx;][exec;][explain;][info;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][workspace;][workspaces;][<scriptName;]" 0
        "example" "2.4.2" "yarn,," \
          "[add;][bin;][cache;][config;][dedupe;][dlx;][exec;][explain;][info;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][<scriptName;]" 1
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.1.0" "yarn,," \
          "[add;][bin;][cache;][config;][dlx;][exec;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][workspace;][workspaces;][<scriptName;]" 0
        "example" "2.1.0" "yarn,," "[add;][bin;][cache;][config;][dlx;][exec;][init;][install;][link;][node;][npm;][pack;][patch;][patch-commit;][rebuild;][remove;][run;][set;][unplug;][up;][why;][plugin;][<scriptName;]" 1
      End

      my_run_test() {
        run_test_override_variables() {
          #shellcheck disable=SC2034
          Y2C_IS_IN_WORKSPACE_PACKAGE="$5"
        }

        run_test "$@"
      }

      It "should assign available words to COMREPLY"
        When call my_run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End

    Describe "y2c_run_yarn_completion(show next non-optional token)"
      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,run,," "[[--inspect,--inspect-brk;][<scriptName;]"
        "example" "2.4.2" "yarn,run,--inspect,-" "[[--inspect,--inspect-brk;-][<scriptName;-]"
        "example" "2.4.2" "yarn,run,--inspect-brk,--inspect,," "[<scriptName;]"
        "example" "2.4.2" "yarn,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,plugin,import,from,sources,--path,#0,--repository,#0,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,-f,," "[<name;]"
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.1.0" "yarn,run,," "[[--inspect,--inspect-brk;][<scriptName;]"
        "example" "2.1.0" "yarn,run,--inspect,-" "[[--inspect,--inspect-brk;-][<scriptName;-]"
        "example" "2.1.0" "yarn,run,--inspect-brk,--inspect,," "[<scriptName;]"
        "example" "2.1.0" "yarn,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,plugin,import,from,sources,--path,#0,--repository,#0,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,-f,," "[<name;]"
      End

      It "should assign available words to COMREPLY"
        When call run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End

    Describe "y2c_run_yarn_completion(workspace command, show next non-optional token)"
      run_test_override_variables() {
        #shellcheck disable=SC2034
        Y2C_TMP_EXPANDED_VAR_RESULT=("@test")
      }

      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,workspace,@test,run,," "[[--inspect,--inspect-brk;][<scriptName;]"
        "example" "2.4.2" "yarn,workspace,@test,run,--inspect,-" "[[--inspect,--inspect-brk;-][<scriptName;-]"
        "example" "2.4.2" "yarn,workspace,@test,run,--inspect-brk,--inspect,," "[<scriptName;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--path,#0,--repository,#0,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,-f,," "[<name;]"
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.1.0" "yarn,workspace,@test,run,," "[[--inspect,--inspect-brk;][<scriptName;]"
        "example" "2.1.0" "yarn,workspace,@test,run,--inspect,-" "[[--inspect,--inspect-brk;-][<scriptName;-]"
        "example" "2.1.0" "yarn,workspace,@test,run,--inspect-brk,--inspect,," "[<scriptName;]"
        "example" "2.1.0" "yarn,workspace,@test,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,workspace,@test,plugin,import,from,sources,--path,#0,--repository,#0,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,workspace,@test,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,workspace,@test,plugin,import,from,sources,--path,#0,--repository,#0,--branch,#0,--no-minify,-f,," "[<name;]"
      End

      It "should assign available words to COMREPLY"
        When call run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End

    Describe "y2c_run_yarn_completion(optional token with variables)"
      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,plugin,import,from,sources,--branch,," "#0"
        "example" "2.4.2" "yarn,plugin,import,from,sources,--branch,test,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,plugin,import,from,sources,--branch,test,--path,," "#0"
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.1.0" "yarn,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,plugin,import,from,sources,--branch,," "#0"
        "example" "2.1.0" "yarn,plugin,import,from,sources,--branch,test,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.1.0" "yarn,plugin,import,from,sources,--branch,test,--path,," "#0"
      End

      It "should assign available words to COMREPLY"
        When call run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End

    Describe "y2c_run_yarn_completion(workspace command, optional token with variables)"
      run_test_override_variables() {
        #shellcheck disable=SC2034
        Y2C_TMP_EXPANDED_VAR_RESULT=("@test")
      }

      Parameters
        "setup" "2.4.2" "Mi40LjI_"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--branch,," "#0"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--branch,test,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--branch,test,--path,," "#0"
        "setup" "2.1.0" "Mi4xLjA_"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--branch,," "#0"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--branch,test,," "[[--path #0,--repository #0,--branch #0,--no-minify,-f|--force;][<name;]"
        "example" "2.4.2" "yarn,workspace,@test,plugin,import,from,sources,--branch,test,--path,," "#0"
      End

      It "should assign available words to COMREPLY"
        When call run_test "$@"
        The output should satisfy the_spec "$@"
      End
    End
  End

  Describe "y2c_yarn_completion_for_complete"
    y2c_run_yarn_completion_has_been_called=0
    y2c_run_yarn_completion() {
      y2c_run_yarn_completion_has_been_called=1
    }

    run_test() {
      y2c_run_yarn_completion_has_been_called=0
      #shellcheck disable=SC2034
      Y2C_IS_YARN_2_REPO=0
      y2c_yarn_completion_for_complete
      echo "$y2c_run_yarn_completion_has_been_called"

      y2c_run_yarn_completion_has_been_called=0
      #shellcheck disable=SC2034
      Y2C_IS_YARN_2_REPO=1
      y2c_yarn_completion_for_complete
      echo "$y2c_run_yarn_completion_has_been_called"
    }

    It "should call y2c_run_yarn_completion"
      When call run_test
      The line 1 of output should equal 1
      The line 2 of output should equal 1
    End
  End

  Describe "y2c_yarn_completion_main"
    declaration_file="/tmp/y2c_yarn_completion_main_preserve_"

    inspect_y2c_detect_environment_called=0
    inspect_y2c_install_hooks_called=0
    inspect_y2c_complete_called=0
    inspect_y2c_set_detect_environment_status=0
    inspect_y2c_completion_main_failed=0

    y2c_detect_environment() {
      inspect_y2c_detect_environment_called=1
      return ${inspect_y2c_set_detect_environment_status}
    }

    y2c_install_hooks() {
      inspect_y2c_install_hooks_called=1
    }

    complete() {
      inspect_y2c_complete_called=1
    }

    run_test() {
      inspect_y2c_detect_environment_called=0
      inspect_y2c_install_hooks_called=0
      inspect_y2c_complete_called=0
      inspect_y2c_set_detect_environment_status=1
      inspect_y2c_completion_main_failed=0
      y2c_yarn_completion_main || inspect_y2c_completion_main_failed=1
      preserve_global_y2c_var "${declaration_file}1" "inspect_y2c_"

      #shellcheck disable=SC2034
      inspect_y2c_detect_environment_called=0
      #shellcheck disable=SC2034
      inspect_y2c_install_hooks_called=0
      #shellcheck disable=SC2034
      inspect_y2c_complete_called=0
      inspect_y2c_set_detect_environment_status=0
      inspect_y2c_completion_main_failed=0
      #shellcheck disable=SC2034
      y2c_yarn_completion_main || inspect_y2c_completion_main_failed=1
      preserve_global_y2c_var "${declaration_file}2" "inspect_y2c_"
    }

    It "should call specific functions"
      When call run_test
      #shellcheck disable=SC1090
      source "${declaration_file}1"
      The variable inspect_y2c_completion_main_failed should equal 1
      The variable inspect_y2c_detect_environment_called should equal 1
      The variable inspect_y2c_install_hooks_called should equal 0
      The variable inspect_y2c_complete_called should equal 0
      #shellcheck disable=SC1090
      source "${declaration_file}2"
      The variable inspect_y2c_completion_main_failed should equal 0
      The variable inspect_y2c_detect_environment_called should equal 1
      The variable inspect_y2c_install_hooks_called should equal 1
      The variable inspect_y2c_complete_called should equal 1
    End
  End

  Describe "y2c_expand_commandName_variable"
    declaration_file_prefix="/tmp/y2c_expand_command_name_var_"

    #shellcheck disable=SC2034
    Y2C_PACKAGE_NAME_PATH_L3lhcm4tcmVwby90ZXN0MQ___d3JrLWE_="./workspace-a/package.json"
    #shellcheck disable=SC2034
    Y2C_PACKAGE_NAME_PATH_L3lhcm4tcmVwby90ZXN0MQ___d3JrLWI_="./workspace-b/package.json"
    #shellcheck disable=SC2034
    Y2C_PACKAGE_NAME_PATH_L3lhcm4tcmVwby90ZXN0Mw___d3JrLWE_="./packages/workspace-a/package.json"
    #shellcheck disable=SC2034
    Y2C_PACKAGE_NAME_PATH_L3lhcm4tcmVwby90ZXN0Mw___d3JrLWQ_="./packages/workspace-d/package.json"

    Parameters
      "setup" 1 "/yarn-repo/test1" "L3lhcm4tcmVwby90ZXN0MQ__"
      "example" 1 "yarn,add,,"
      "example" 1 "yarn,workspace,wrk-a,," "build setup test deploy"
      "example" 1 "yarn,workspace,wrk-b,," "dev run start build"
      "setup" 2 "/yarn-repo/test3" "L3lhcm4tcmVwby90ZXN0Mw__"
      "example" 2 "yarn,workspace,wrk-a,," "install uninstall"
      "example" 2 "yarn,workspace,wrk-d,,"
    End

    run_test() {
      local type="$1"
      local result=""
      local declaration_file="${declaration_file_prefix}$2"

      case "$type" in
      setup)
        [[ -f "$declaration_file" ]] && return 0
        #shellcheck disable=SC2034
        Y2C_CURRENT_ROOT_REPO_BASE64_PATH="$4"
        preserve_global_y2c_var "${declaration_file}"
        echo "cd \"$3\"" >>"${declaration_file}"
        ;;
      example)
        # shellcheck disable=SC1090
        source "${declaration_file}"
        IFS="," read -r -a COMP_WORDS <<<"$3"
        #shellcheck disable=SC2034
        Y2C_TMP_EXPANDED_VAR_RESULT=()
        y2c_detect_environment
        y2c_expand_commandName_variable
        ;;
      esac
    }

    It "should set up Y2C_TMP_EXPANDED_VAR_RESULT correctly"
      When call run_test "$@"
      if [[ $1 = 'example' ]]; then
        if [[ -z $4 ]]; then
          The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should be blank
        else
          The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should equal "$4"
        fi
      else
        The path "${declaration_file_prefix}$2" should be file
      fi
    End
  End

  Describe "y2c_generate_system_executables"
    Parameters
      0 "/usr/local/bin"
      1 "/usr/local/bin" "bash bashbug docker-entrypoint.sh kcov kcov-system-daemon"
    End

    run_test() {
      #shellcheck disable=SC2034
      Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV="$1"
      y2c_generate_system_executables "$2"
    }

    It "should assign a list of commands by a given path to Y2C_SYSTEM_EXECUTABLES"
      When call run_test "$@"
      if [[ -z $3 ]]; then
        The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should be blank
      else
        The variable "Y2C_SYSTEM_EXECUTABLES[*]" should equal "$3"
      fi
    End
  End

  Describe "y2c_expand_scriptName_variable"
    declaration_file="/tmp/y2c_expand_scriptName_variable_preserve_"
    Parameters
      "yarn,run,," \
        "/yarn-repo/test1" "dev test" \
        "/yarn-repo/test1/workspace-a" "build setup test deploy" \
        "/yarn-repo/test1/workspace-c" blank \
        "/yarn-repo/test1" "dev test"
    End

    run_test() {
      declare -i index=0
      IFS="," read -r -a COMP_WORDS <<<"$1"
      shift

      while [[ $# -gt 0 ]]; do
        cd "$1" || return 0
        y2c_expand_scriptName_variable
        preserve_global_y2c_var "${declaration_file}${index}" "Y2C_TMP_EXPANDED_VAR_RESULT"
        index+=1
        shift 2
      done
    }

    It "should set up Y2C_TMP_EXPANDED_VAR_RESULT correctly"
      When call run_test "$@"

      shift
      declare -i index=0

      while [[ $# -gt 0 ]]; do
        # shellcheck disable=SC1090
        source "${declaration_file}${index}"
        if [[ $2 = "blank" ]]; then
          The variable Y2C_TMP_EXPANDED_VAR_RESULT should be blank
        else
          The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should equal "$2"
        fi

        index+=1
        shift 2
      done
    End
  End

  Describe "y2c_expand_scriptName_variable(workspace commands)"
    declaration_file="/tmp/y2c_expand_scriptName_variable_for_workspace_preserve_"

    #shellcheck disable=SC2034
    Y2C_PACKAGE_NAME_PATH_L3lhcm4tcmVwby90ZXN0MQ___d3JrLWE_="./workspace-a/package.json"
    #shellcheck disable=SC2034
    Y2C_PACKAGE_NAME_PATH_L3lhcm4tcmVwby90ZXN0Mw___d3JrLWE_="./packages/workspace-a/package.json"

    Parameters
      "yarn,workspace,wrk-a,run,," \
        "/yarn-repo/test1" "L3lhcm4tcmVwby90ZXN0MQ__" "build setup test deploy" \
        "/yarn-repo/test3" "L3lhcm4tcmVwby90ZXN0Mw__" "install uninstall"
    End

    run_test() {
      declare -i index=0
      IFS="," read -r -a COMP_WORDS <<<"$1"
      shift

      while [[ $# -gt 0 ]]; do
        cd "$1" || return 0
        #shellcheck disable=SC2034
        Y2C_CURRENT_ROOT_REPO_BASE64_PATH="$2"
        y2c_expand_scriptName_variable
        preserve_global_y2c_var "${declaration_file}${index}" "Y2C_TMP_EXPANDED_VAR_RESULT"
        index+=1
        shift 3
      done
    }

    It "should set up Y2C_TMP_EXPANDED_VAR_RESULT correctly"
      When call run_test "$@"

      shift
      declare -i index=0

      while [[ $# -gt 0 ]]; do
        # shellcheck disable=SC1090
        source "${declaration_file}${index}"
        The variable "Y2C_TMP_EXPANDED_VAR_RESULT[*]" should equal "$3"
        index+=1
        shift 3
      done
    End
  End
End
