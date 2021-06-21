#!/usr/bin/env bash

# Variable and function naming rules:
# 1. All the global variables should be preceded with "Y2C_".
# 2. All the function names should be preceded with "y2c_".
# 3. The word command in this script means a series of tokens identified
#     and recognized by yarn executable to perform a specific action.
#     For example, "yarn add --json react" is a command.
#
# 4. A token is a unit consumed by the script to do word completion;
#     it belongs to one of the following categories:
#    4-1: Order: the single word, like add, workspace, config, etc.
#    4-2: Option: The square brackets wrap around the token indicate that it is an option,
#                 which means a user can skip it.
#    4-3: Variable: The angle brackets enclose the token suggests that it is a variable,
#                   which the value depends on the command, the environment, or the repository itself.

Y2C_COMPLETION_SCRIPT_LOCATION=$(dirname "${BASH_SOURCE[0]}")

Y2C_COMMAND_TOKENS_VARNAME_PREFIX="YARN_COMMAND_TOKENS_"
Y2C_WORKSPACE_COMMAND_TOKENS_VARNAME_PREFIX="YARN_WORKSPACE_COMMAND_TOKENS_"
Y2C_COMMAND_TOKENS_LIST_VERSION_REF_PREFIX="YARN_COMMAND_TOKENS_LIST_VER_"
Y2C_PACKAGE_NAME_PATH_PREFIX="Y2C_PACKAGE_NAME_PATH_"
Y2C_REPO_ROOT_YARN_VERSION_VAR_NAME_PREFIX="Y2C_REPO_YARN_VERSION_"
Y2C_REPO_ROOT_YARN_BASE64_VERSION_VAR_NAME_PREFIX="Y2C_REPO_YARN_BASE64_VERSION_"
Y2C_REPO_ROOT_IS_YARN_2_VAR_NAME_PREFIX="Y2C_REPO_IS_YARN_2_"
Y2C_WORKSPACE_PACKAGES_PREFIX="Y2C_WORKSPACE_PACKAGES_"

Y2C_COMMAND_END_MARK="yarn_command_end_mark_for_prorcesing_last_token"
Y2C_ALTERNATIVE_OPTIONS_SEPARATOR="|"
Y2C_OPTION_SEPARATOR=","
Y2C_VARIABLE_SYMBOL='<'

declare -i Y2C_YARN_WORD_IS_ORDER=1
declare -i Y2C_YARN_WORD_IS_OPTION=2
declare -i Y2C_YARN_WORD_IS_VARIABLE=3

declare -i Y2C_COMMAND_WORDS_MATCH_OPTION=0
declare -i Y2C_COMMAND_WORDS_NOT_MATCH_OPTION=1
declare -i Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION=2

declare -i Y2C_FUNC_ARG_IS_STR=0
declare -i Y2C_FUNC_ARG_IS_ARR=1

declare -a Y2C_TMP_IDENTIFIED_TOKENS=()
declare -a Y2C_TMP_ALTERNATIVE_OPTIONS=()
declare -a Y2C_SYSTEM_EXECUTABLES=()
declare -i Y2C_TMP_OPTION_WORDS_NUM=0

Y2C_TMP_EXPANDED_VAR_RESULT=()

IS_SUPPORT_DECLARE_N_FLAG=1
IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT=1

declare -i Y2C_IS_YARN_2_REPO=0
declare -i Y2C_SETUP_HIT_CACHE=0

Y2C_YARN_VERSION=""
Y2C_YARN_BASE64_VERSION=""
Y2C_CURRENT_ROOT_REPO_PATH=""
Y2C_CURRENT_ROOT_REPO_BASE64_PATH=""
Y2C_VERBOSE=0
Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=1
Y2C_IS_IN_WORKSPACE_PACKAGE=0

y2c_is_verbose_output() {
  return $((Y2C_VERBOSE ^ 1))
}

y2c_setup() {
  declare -i is_yarn_2=0
  declare -i subscript=0

  local root_repo_path="${1:-"$PWD"}"
  local yarn_version_var_name=""
  local yarn_base64_version_var_name=""
  local is_yarn_2_var_name=""
  local available_paths=()
  local checking_path=""

  [[ $Y2C_TESTING_MODE -eq 1 ]] && Y2C_SETUP_HIT_CACHE=0

  Y2C_IS_IN_WORKSPACE_PACKAGE=0

  if [[ -f "${root_repo_path}/yarn.lock" ]]; then
    Y2C_CURRENT_ROOT_REPO_PATH="${root_repo_path}"
    Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
    yarn_version_var_name="${Y2C_REPO_ROOT_YARN_VERSION_VAR_NAME_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"
    yarn_base64_version_var_name="${Y2C_REPO_ROOT_YARN_BASE64_VERSION_VAR_NAME_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"
    is_yarn_2_var_name="${Y2C_REPO_ROOT_IS_YARN_2_VAR_NAME_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"

    if [[ -n ${!yarn_version_var_name} ]]; then
      y2c_is_verbose_output && echo "[Y2C] Found the cache, restoring it" 1>&2

      Y2C_YARN_VERSION="${!yarn_version_var_name}"
      Y2C_IS_YARN_2_REPO=${!is_yarn_2_var_name}
      Y2C_YARN_BASE64_VERSION="${!yarn_base64_version_var_name}"
      # shellcheck disable=SC2034
      [[ $Y2C_TESTING_MODE -eq 1 ]] && Y2C_SETUP_HIT_CACHE=1

    elif command -v yarn >/dev/null 2>&1; then
      y2c_is_verbose_output && echo "[Y2C] Found the repository hosted by yarn" 1>&2

      Y2C_YARN_VERSION=$(y2c_is_yarn_2)
      is_yarn_2=$(($? ^ 1))
      Y2C_YARN_BASE64_VERSION=$(y2c_get_var_name "${Y2C_YARN_VERSION}")

      Y2C_IS_YARN_2_REPO=$is_yarn_2

      if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
        declare -n yarn_version_ref="${yarn_version_var_name}"
        declare -n yarn_is_yarn2_ref="${is_yarn_2_var_name}"
        declare -n yarn_base64_version_ref="${yarn_base64_version_var_name}"
        # shellcheck disable=SC2034
        yarn_version_ref="${Y2C_YARN_VERSION}"
        # shellcheck disable=SC2034
        yarn_is_yarn2_ref="${is_yarn_2}"
        # shellcheck disable=SC2034
        yarn_base64_version_ref="${Y2C_YARN_BASE64_VERSION}"
      else
        eval "$yarn_version_var_name=$Y2C_YARN_VERSION"
        eval "$yarn_base64_version_var_name=$Y2C_YARN_BASE64_VERSION"
        eval "$is_yarn_2_var_name=$is_yarn_2"
      fi
    fi

    if [[ Y2C_IS_YARN_2_REPO -eq 1 ]]; then
      y2c_generate_yarn_command_list
      y2c_generate_workspace_packages
      y2c_generate_system_executables "${PATH}"
    else
      y2c_is_verbose_output && echo "[Y2C] yarn-2-completion won't run on this repository(yarn 2+ is required)" 1>&2
    fi

    return 0
  elif [[ -z $1 ]] && [[ -f "./package.json" ]]; then
    if [[ -n "${Y2C_CURRENT_ROOT_REPO_PATH}" ]] && [[ $PWD = "${Y2C_CURRENT_ROOT_REPO_PATH}"* ]]; then
      Y2C_IS_IN_WORKSPACE_PACKAGE=1
      return 0
    else
      checking_path="${PWD}"
      while [[ -n $checking_path ]]; do
        checking_path="${checking_path%/*}"
        available_paths+=("${checking_path}")
      done

      # shellcheck disable=SC2015
      [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || subscript=${#available_paths[@]}-1
      unset "available_paths[$subscript]"

      for checking_path in "${available_paths[@]}"; do
        if y2c_setup "${checking_path}"; then
          Y2C_IS_IN_WORKSPACE_PACKAGE=1
          return 0
        fi
      done

      return 1
    fi
  fi

  return 1
}

y2c_generate_workspace_packages() {
  local repo_package_path="${Y2C_CURRENT_ROOT_REPO_PATH}/package.json"
  local package_json_path=""
  local node_commands=""
  local package_names=()
  local package_name=""
  local package_path=""
  local package_paths=()
  local existed_package_paths=()
  local workspace_packagaes_var_name=""

  if ! [[ -f "${repo_package_path}" ]]; then
    return 0
  fi

  workspace_packagaes_var_name="${Y2C_WORKSPACE_PACKAGES_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"
  if [[ -n ${!workspace_packagaes_var_name} ]]; then
    y2c_is_verbose_output && echo "[Y2C] Found the cache of workspace packges" 1>&2
    return 0
  fi

  y2c_is_verbose_output && echo "[Y2C] Finding all the workspace's packages and cache them" 1>&2

  # shellcheck disable=SC2207
  package_paths=($(node -e "console.log((require('${repo_package_path}').workspaces || []).join(' '))"))

  for package_path in "${package_paths[@]}"; do
    package_json_path="./${package_path}/package.json"

    if [[ -f "${package_json_path}" ]]; then
      node_commands+="console.log(require('$package_json_path').name);"
      existed_package_paths+=("${package_json_path}")
    fi
  done

  { while read -r package_name; do package_names+=("${package_name}"); done; } < <(node -e "${node_commands}")

  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n store_map_ref="${workspace_packagaes_var_name}"
    # shellcheck disable=2034
    store_map_ref=("${package_names[@]}")
  else
    eval "$workspace_packagaes_var_name=(\"\${package_names[@]}\")"
  fi

  y2c_set_package_name_path_map "package_names[@]" "existed_package_paths[@]"
}

y2c_generate_system_executables() {
  if [[ $Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV -eq 0 ]] || [[ ${#Y2C_SYSTEM_EXECUTABLES[@]} -ne 0 ]]; then
    return 0
  fi

  local path_to_be_expanding="${1}:"
  local expanded_path=()
  local system_executable=""
  local executable_name=""

  IFS=":" read -r -a expanded_path <<<"${path_to_be_expanding//:/\/*:}"

  Y2C_SYSTEM_EXECUTABLES=()

  # shellcheck disable=SC2068
  for system_executable in ${expanded_path[@]}; do
    if [[ -x $system_executable ]]; then
      executable_name="${system_executable##*/}"
      Y2C_SYSTEM_EXECUTABLES+=("${executable_name}")
    fi
  done
}

y2c_get_package_json_scripts_keys() {
  local package_json_path="$1"
  local node_command="console.log(Object.keys(require('${package_json_path}').scripts || {}).join(' '))"

  if [[ -f $package_json_path ]]; then
    node -e "${node_command}"
  else
    echo ""
  fi
}

y2c_expand_commandName_variable() {
  local current_command="${COMP_WORDS[*]}"
  local prior_token=""
  local package_path_var_name=""

  case "${current_command}" in
  "yarn workspace"*)
    if [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]]; then
      prior_token="${COMP_WORDS[-2]}"
    else
      declare -i index=${#COMP_WORDS[@]}-2
      prior_token="${COMP_WORDS[index]}"
    fi

    package_path_var_name=$(y2c_get_var_name "${prior_token}" "${Y2C_PACKAGE_NAME_PATH_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}_")
    read -r -a Y2C_TMP_EXPANDED_VAR_RESULT < <(y2c_get_package_json_scripts_keys "${PWD}/${!package_path_var_name}")
    ;;
  "yarn exec"*)
    Y2C_TMP_EXPANDED_VAR_RESULT=("${Y2C_SYSTEM_EXECUTABLES[@]}")
    ;;
  esac
}

y2c_expand_workspaceName_variable() {
  local var_name=""

  var_name="${Y2C_WORKSPACE_PACKAGES_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}[@]"
  Y2C_TMP_EXPANDED_VAR_RESULT=("${!var_name}")
}

y2c_expand_scriptName_variable() {
  read -r -a Y2C_TMP_EXPANDED_VAR_RESULT < <(y2c_get_package_json_scripts_keys "${PWD}/package.json")
}

y2c_set_expand_var() {
  local var_name="$1"
  local function_name=""

  shift 1

  Y2C_TMP_EXPANDED_VAR_RESULT=()

  if ! [[ $var_name = "$Y2C_VARIABLE_SYMBOL"* ]]; then
    Y2C_TMP_EXPANDED_VAR_RESULT=("${var_name}")
    return 0
  fi

  function_name="y2c_expand_${var_name#$Y2C_VARIABLE_SYMBOL}_variable"

  if declare -f "${function_name}" >/dev/null 2>&1; then
    $function_name "$@"
  else
    Y2C_TMP_EXPANDED_VAR_RESULT=("${var_name#$Y2C_VARIABLE_SYMBOL}")
  fi
}

y2c_get_command_tokens_var_name() {
  local base64_yarn_version="$1"
  local index="$2"
  echo "${Y2C_COMMAND_TOKENS_VARNAME_PREFIX}${base64_yarn_version}_${index}"
}

y2c_expand_yarn_workspace_command_list() {
  local yarn_command_workspace_var_name="${1}"
  local yarn_command_tokens_list_var_name="${2}"
  local yarn_command_workspace_ref="${yarn_command_workspace_var_name}[@]"
  local yarn_command_tokens_list_ref="${yarn_command_tokens_list_var_name}[@]"
  local yarn_command_tokens_var_name=""
  local yarn_command_tokens_ref=""

  local base64_yarn_version="$3"

  declare -i store_yarn_command_index=0

  local token=""
  local workspace_recursive_command=()
  local store_yarn_command_var_name=""
  local appending_tokens=()

  for yarn_command_tokens_var_name in "${!yarn_command_tokens_list_ref}"; do
    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
      declare -n yarn_command_tokens="${yarn_command_tokens_var_name}"
    else
      yarn_command_tokens_ref="${yarn_command_tokens_var_name}[@]"
      yarn_command_tokens=("${!yarn_command_tokens_ref}")
    fi

    if [[ ${yarn_command_tokens[*]} = "yarn workspace"* ]] ||
      [[ ${yarn_command_tokens[*]} = "yarn workspaces"* ]]; then
      continue
    fi

    workspace_recursive_command=()
    for token in "${!yarn_command_workspace_ref}"; do
      if [[ $token = '<commandName' ]]; then
        appending_tokens=("${yarn_command_tokens[@]}")
        unset "appending_tokens[0]"
        workspace_recursive_command+=("${appending_tokens[@]}")

        break
      else
        workspace_recursive_command+=("$token")
      fi
    done

    store_yarn_command_var_name="${Y2C_WORKSPACE_COMMAND_TOKENS_VARNAME_PREFIX}${base64_yarn_version}_${store_yarn_command_index}"
    store_yarn_command_index+=1

    #Y2C_COMMAND_TOKENS_REF[${#Y2C_COMMAND_TOKENS_REF[@]}]="${store_yarn_command_var_name}"
    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
      declare -n store_yarn_command_ref="${store_yarn_command_var_name}"
      # shellcheck disable=SC2034
      store_yarn_command_ref=("${workspace_recursive_command[@]}")

      declare -n store_yarn_command_tokens_list_ref="${yarn_command_tokens_list_var_name}"
      store_yarn_command_tokens_list_ref+=("${store_yarn_command_var_name}")
    else
      eval "$store_yarn_command_var_name=(\""'${workspace_recursive_command[@]}'"\")"
      eval "$yarn_command_tokens_list_var_name+=(\"${store_yarn_command_var_name}\")"
    fi
  done
}

y2c_is_yarn_2() {
  local yarn_version
  yarn_version=$(yarn --version)

  echo "${yarn_version}"

  if [[ ${yarn_version%%.*} -lt 2 ]]; then
    return 1
  fi

  return 0
}

y2c_generate_yarn_command_list() {
  local yarn_command_tokens_list_var_name

  yarn_command_tokens_list_var_name="${Y2C_COMMAND_TOKENS_LIST_VERSION_REF_PREFIX}${Y2C_YARN_BASE64_VERSION}"

  if [[ -n ${!yarn_command_tokens_list_var_name} ]]; then
    y2c_is_verbose_output && echo "[Y2C] Found the cache of yarn commands of verson ${Y2C_YARN_VERSION}" 1>&2
    return 0
  fi

  y2c_is_verbose_output && echo "[Y2C] Creating yarn commands of version ${Y2C_YARN_VERSION} for speeding up completion" 1>&2

  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_tokens_list_ref="${yarn_command_tokens_list_var_name}"
    yarn_command_tokens_list_ref=()
  else
    eval "$yarn_command_tokens_list_var_name=()"
  fi

  if ! command -v yarn >/dev/null 2>&1; then
    echo "Yarn executable is not found, yarn-2-completion won't activate" 1>&2
    return 1
  fi

  declare -i word_is_option=0
  declare -i previous_word_is_option=0
  declare -i store_yarn_command_index=0
  declare -i subscript=0

  local assembling_option=""
  local yarn_command_broken_words=()
  local yarn_command_words=()
  local store_yarn_command_var_name=""
  local broken_word=""
  local yarn_command_workspace_var_name=""
  local instructions=()

  local options=()

  while IFS='' read -r line; do instructions+=("$line"); done <<<"$(yarn --help | grep -E '^[[:space:]]+yarn')"

  for instruction in "${instructions[@]}"; do
    previous_word_is_option=0

    instruction+=" ${Y2C_COMMAND_END_MARK}"
    IFS=" " read -r -a yarn_command_broken_words <<<"$instruction"

    yarn_command_words=()

    for broken_word in "${yarn_command_broken_words[@]}"; do
      if [[ $broken_word = \[* ]] || [[ -n $assembling_option ]]; then
        word_is_option=1
      else
        word_is_option=0
      fi

      broken_word=${broken_word//,/$Y2C_ALTERNATIVE_OPTIONS_SEPARATOR}

      if [[ word_is_option -eq 1 ]]; then
        if [[ $previous_word_is_option -eq 1 ]]; then
          broken_word="${broken_word#[}"
        fi

        if [[ -n $assembling_option ]]; then
          assembling_option+=" ${broken_word}"
        else
          assembling_option="${broken_word}"
        fi

        if [[ $broken_word = *$'\x5d' ]]; then
          assembling_option="${assembling_option%]}"
          assembling_option="${assembling_option%>}"

          if [[ $previous_word_is_option -eq 1 ]]; then
            # shellcheck disable=SC2015
            [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || subscript=${#yarn_command_words[@]}-1
            yarn_command_words[subscript]+="${Y2C_OPTION_SEPARATOR}${assembling_option}"

          else
            yarn_command_words+=("${assembling_option}")
          fi

          previous_word_is_option=$word_is_option
          assembling_option=
        fi
      else
        if [[ $previous_word_is_option -eq 1 ]]; then
          # shellcheck disable=SC2015
          [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || subscript=${#yarn_command_words[@]}-1

          IFS=',' read -r -a options <<<"${yarn_command_words[subscript]}"
          for ((i = 0; i < ${#options[@]} - 1; ++i)); do
            # shellcheck disable=SC2015
            [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || subscript=${#yarn_command_words[@]}-1
            yarn_command_words+=("${yarn_command_words[subscript]}")
          done
        fi

        if ! [[ $broken_word = "$Y2C_COMMAND_END_MARK" ]]; then
          broken_word="${broken_word%]}"
          broken_word="${broken_word%>}"

          yarn_command_words+=("${broken_word}")
          previous_word_is_option=$word_is_option
        fi
      fi
    done

    store_yarn_command_var_name="$(y2c_get_command_tokens_var_name "${Y2C_YARN_BASE64_VERSION}" "${store_yarn_command_index}")"
    store_yarn_command_index+=1

    if [[ IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
      yarn_command_tokens_list_ref[${#yarn_command_tokens_list_ref[@]}]="${store_yarn_command_var_name}"

      declare -n store_yarn_command_tokens_ref="${store_yarn_command_var_name}"
      # shellcheck disable=SC2034
      store_yarn_command_tokens_ref=("${yarn_command_words[@]}")
    else
      eval "${yarn_command_tokens_list_var_name}+=("'"'"${store_yarn_command_var_name}"'"'")"
      eval "$store_yarn_command_var_name=("'"''${yarn_command_words[@]}''"'")"
    fi

    if [[ $instruction = *"yarn workspace "* ]]; then
      yarn_command_workspace_var_name="${store_yarn_command_var_name}"
    fi
  done

  y2c_expand_yarn_workspace_command_list "${yarn_command_workspace_var_name}" "${yarn_command_tokens_list_var_name}" "${base64_yarn_version}"
}

y2c_get_identified_token() {
  local token="$1"

  if [[ $token = \[* ]]; then
    token="${token#[}"
    IFS="${Y2C_OPTION_SEPARATOR}" read -r -a Y2C_TMP_IDENTIFIED_TOKENS <<<"$token"

    return $Y2C_YARN_WORD_IS_OPTION
  elif [[ $token = \<* ]]; then
    Y2C_TMP_IDENTIFIED_TOKENS=("${token}")
    return $Y2C_YARN_WORD_IS_VARIABLE
  else
    Y2C_TMP_IDENTIFIED_TOKENS=("${token}")
    return $Y2C_YARN_WORD_IS_ORDER
  fi
}

y2c_set_alternative_options() {
  local token="$1"

  IFS="${Y2C_ALTERNATIVE_OPTIONS_SEPARATOR}" read -r -a Y2C_TMP_ALTERNATIVE_OPTIONS <<<"$token"
}

y2c_add_word_to_comreply() {
  local processing_word="$1"
  local completing_word="$2"
  local current_command="${COMP_WORDS[*]}"

  if ! [[ " ${current_command} " = *" ${processing_word} "* ]] &&
    [[ ${processing_word} = "${completing_word}"* ]]; then
    COMPREPLY+=("${processing_word}")
  fi
}

y2c_add_word_candidates() {
  local token="$1"
  local completing_word="$2"

  local current_command="${COMP_WORDS[*]}"
  declare -i token_type
  local processing_token=""
  local copied_identified_tokens=()
  local alternative_options=()
  local option=""
  local expanded_var=""

  y2c_get_identified_token "${token}"
  token_type=$?

  copied_identified_tokens=("${Y2C_TMP_IDENTIFIED_TOKENS[@]}")

  for processing_token in "${copied_identified_tokens[@]}"; do
    case "$token_type" in
    "$Y2C_YARN_WORD_IS_ORDER")
      y2c_add_word_to_comreply "${processing_token}" "${completing_word}"
      ;;
    "$Y2C_YARN_WORD_IS_OPTION")
      y2c_set_alternative_options "${processing_token}"
      alternative_options=("${Y2C_TMP_ALTERNATIVE_OPTIONS[@]}")

      for option in "${alternative_options[@]}"; do
        if [[ " ${current_command} " = *" ${option%% *} "* ]]; then
          continue 2
        fi
      done

      if [[ -z $completing_word ]]; then
        COMPREPLY+=("${alternative_options[@]}")
      else
        for option in "${alternative_options[@]}"; do
          if [[ ${option} = "$completing_word"* ]]; then
            COMPREPLY+=("${option}")
          fi
        done
      fi
      ;;
    "$Y2C_YARN_WORD_IS_VARIABLE")
      y2c_set_expand_var "${processing_token}" "${completing_word}"

      for expanded_var in "${Y2C_TMP_EXPANDED_VAR_RESULT[@]}"; do
        y2c_add_word_to_comreply "${expanded_var}" "${completing_word}"
      done
      ;;
    esac
  done
}

y2c_is_commandline_word_match_option() {
  local commandline_word="$1"
  local option="$2"
  local exclusive_option=""

  declare -i comp_word_index=$3
  declare -i comp_words_num=${#COMP_WORDS[@]}
  declare -i index=0
  declare -i checking_comp_word_index=0
  local option_words=()

  Y2C_TMP_OPTION_WORDS_NUM=0

  y2c_set_alternative_options "${option}"
  for exclusive_option in "${Y2C_TMP_ALTERNATIVE_OPTIONS[@]}"; do
    IFS=" " read -r -a option_words <<<"${exclusive_option}"
    if [[ ${commandline_word} = "${option_words[0]}" ]]; then
      Y2C_TMP_OPTION_WORDS_NUM=${#option_words[@]}
      if [[ $Y2C_TMP_OPTION_WORDS_NUM -ne 1 ]]; then
        for ((index = 1; index < Y2C_TMP_OPTION_WORDS_NUM; ++index)); do
          checking_comp_word_index=$comp_word_index+$index
          if [[ $checking_comp_word_index -ge $comp_words_num ]]; then
            break
          fi

          if [[ -z "${COMP_WORDS[checking_comp_word_index]}" ]]; then
            COMPREPLY=("${option_words[index]}")
            return $Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION
          fi
        done
      fi

      return $Y2C_COMMAND_WORDS_MATCH_OPTION
    fi
  done

  return $Y2C_COMMAND_WORDS_NOT_MATCH_OPTION
}

y2c_run_yarn_completion() {
  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_tokens
  else
    local yarn_command_tokens
  fi

  declare -i word_num=${#COMP_WORDS[@]}

  local completing_word="$1"
  local last_word_index=$word_num-1
  local expanded_var=""
  local token_type=""
  local token=""
  local copied_identified_tokens=()
  local option=""
  local processed_tokens=()
  local candidate_token=""
  local next_candidate_token=""
  local option_words=()

  declare -i comp_word_index=0
  declare -i options_start_index=0
  declare -i yarn_command_tokens_index=0

  y2c_process_token_once() {
    local token="$1"
    if [[ " ${processed_tokens[*]} " = *" ${token} "* ]]; then
      return 0
    fi

    processed_tokens+=("${token}")
    y2c_add_word_candidates "${token}" "${completing_word}"
  }

  COMPREPLY=()

  yarn_command_tokens_list_var_name="${Y2C_COMMAND_TOKENS_LIST_VERSION_REF_PREFIX}${Y2C_YARN_BASE64_VERSION}"

  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_tokens_list="${yarn_command_tokens_list_var_name}"
  else
    local yarn_command_tokens_list_name="${yarn_command_tokens_list_var_name}[@]"
    local yarn_command_tokens_list=("${!yarn_command_tokens_list_name}")
  fi

  for yarn_command_tokens in "${yarn_command_tokens_list[@]}"; do
    options_start_index=0
    yarn_command_tokens_index=0

    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 0 ]]; then
      yarn_command_tokens+="[@]"
      yarn_command_tokens=("${!yarn_command_tokens}")
    fi

    if [[ $Y2C_IS_IN_WORKSPACE_PACKAGE -eq 1 ]] && [[ ${yarn_command_tokens[1]} = 'workspace'* ]]; then
      continue
    fi

    for ((comp_word_index = 0; comp_word_index < last_word_index; ++comp_word_index)); do
      y2c_get_identified_token "${yarn_command_tokens[yarn_command_tokens_index++]}"
      token_type=$?

      copied_identified_tokens=("${Y2C_TMP_IDENTIFIED_TOKENS[@]}")

      if [[ $token_type -eq $Y2C_YARN_WORD_IS_OPTION ]]; then
        [[ $options_start_index -eq 0 ]] && options_start_index=$comp_word_index
      else
        options_start_index=0
      fi

      for token in "${copied_identified_tokens[@]}"; do
        case "$token_type" in
        "$Y2C_YARN_WORD_IS_ORDER")
          if [[ ${COMP_WORDS[$comp_word_index]} = "${token}" ]]; then
            continue 2
          fi
          ;;
        "$Y2C_YARN_WORD_IS_OPTION")
          if y2c_is_commandline_word_match_option "${COMP_WORDS[$comp_word_index]}" "${token}" "${comp_word_index}"; then
            comp_word_index+=$Y2C_TMP_OPTION_WORDS_NUM-1
            continue 2
          elif [[ $? -eq $Y2C_COMMAND_WORDS_MISS_WHOLE_OPTION ]]; then
            return 0
          fi
          ;;
        "$Y2C_YARN_WORD_IS_VARIABLE")
          y2c_set_expand_var "${token}" "${completing_word}"

          for expanded_var in "${Y2C_TMP_EXPANDED_VAR_RESULT[@]}"; do
            if [[ ${COMP_WORDS[$comp_word_index]} = "${expanded_var}" ]]; then
              continue 3
            fi
          done
          ;;
        esac
      done

      if [[ $token_type -eq $Y2C_YARN_WORD_IS_OPTION ]]; then
        yarn_command_tokens_index=$options_start_index+${#copied_identified_tokens[@]}
        comp_word_index+=-1
        continue
      fi

      continue 2
    done

    candidate_token="${yarn_command_tokens[yarn_command_tokens_index]}"
    y2c_process_token_once "${candidate_token}"

    #region When the candidates are options for the completing word,
    # it is essential to provide non-option words as candidates for
    # the user to choose from. For example, "yarn run" command accepts
    # two options named "--inspect" and "--inspect-brk";
    # the user can skip those two options and type the script name
    # defined in the package.json directly.
    y2c_get_identified_token "${candidate_token}"
    if [[ $? -ne "${Y2C_YARN_WORD_IS_OPTION}" ]]; then
      continue
    fi

    [[ $options_start_index -eq 0 ]] && options_start_index=$yarn_command_tokens_index
    next_candidate_token="${yarn_command_tokens[$options_start_index + ${#Y2C_TMP_IDENTIFIED_TOKENS[@]}]}"
    if [[ -z "${next_candidate_token}" ]]; then
      continue
    fi
    y2c_process_token_once "${next_candidate_token}"
    #endregion
  done

  return 0
}

y2c_yarn_completion_for_complete() {
  if [[ $Y2C_IS_YARN_2_REPO -eq 0 ]]; then
    return 0
  fi

  y2c_run_yarn_completion "$2"
}

y2c_get_var_name() {
  local str_list="$1"
  local prefix="$2"
  local str_list_type="${3:-$Y2C_FUNC_ARG_IS_STR}"
  local node_commands=""
  local encoded_list=""
  local str=""

  get_node_commands() {
    str="${str//"'"/\\\'}"
    str="${str//"\\"/\\\\}"
    node_commands+="console.log('${prefix//"'"/\\\'}' + Buffer.from('${str}').toString('base64'));"
  }

  if [[ $str_list_type -eq $Y2C_FUNC_ARG_IS_STR ]]; then
    str="${str_list}"
    get_node_commands
  elif [[ $str_list_type -eq $Y2C_FUNC_ARG_IS_ARR ]]; then
    for str in "${!str_list}"; do
      get_node_commands
    done
  fi

  encoded_list=$(node -e "${node_commands}")
  encoded_list="${encoded_list//"="/_}"
  encoded_list="${encoded_list//"+"/_A}"
  echo "${encoded_list//"/"/_B}"
}

y2c_set_package_name_path_map() {
  local package_names_ref="$1"
  local package_paths=("${!2}")
  local var_names_for_package_names=()

  # shellcheck disable=SC2207
  var_names_for_package_names=($(y2c_get_var_name "${package_names_ref}" "${Y2C_PACKAGE_NAME_PATH_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}_" $Y2C_FUNC_ARG_IS_ARR))

  if [[ IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    for index in "${!var_names_for_package_names[@]}"; do
      declare -n package_name_path_ref="${var_names_for_package_names[$index]}"
      # shellcheck disable=SC2034
      package_name_path_ref="${package_paths[$index]}"
    done
  else
    for index in "${!var_names_for_package_names[@]}"; do
      eval "${var_names_for_package_names[$index]}="'"'"${package_paths[$index]}"'"'
    done
  fi
}

y2c_detect_environment() {
  if [ -z "${BASH_VERSINFO[0]}" ]; then
    echo "Sorry, the yarn completion only supports BASH" 1>&2
    return 1
  fi

  if [[ ${BASH_VERSINFO[0]} -lt 3 ]]; then
    echo "The yarn completion needs BASH 3+ to function properly" 1>&2
    return 1
  fi

  # shellcheck disable=SC2034
  if ! declare -n declare_n_flag_test >/dev/null 2>&1; then
    IS_SUPPORT_DECLARE_N_FLAG=0
  fi

  if ! "${Y2C_COMPLETION_SCRIPT_LOCATION}/syntax-checker/negative-subscript.sh" >/dev/null 2>&1; then
    IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT=0
  fi
}

y2c_yarn_completion_main() {
  if ! y2c_detect_environment; then
    return 1
  fi

  y2c_setup
  # shellcheck disable=SC1091
  . "$(dirname "${BASH_SOURCE[0]}")/builtin-hook.sh"

  complete -F y2c_yarn_completion_for_complete -o bashdefault -o default yarn
}
