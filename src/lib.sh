#!/usr/bin/env bash

# Variable and function naming rules:
# 1. All the global environment variables should be preceded with the string literal "Y2C_".
# 2. All the function names should be preceded with "y2c_" string literal.
# 3. The word command in this script means a series of tokens that can be identified
#     and recognized by yarn executable to perform a specific action.
#     For example, "yarn add --json react" is a command.
#
# 4. A token is a unit consumed by the script to do word completion; it is of one of three following categories:
#    4-1: Order: the single word, like add, workspace, config, etc.
#    4-2: Option: The square brackets wrap around the token indicates that this is an option,
#                 which means a user can skip it.
#    4-3: Variable: The angle brackets enclose the token suggests that it is a variable,
#                   which a valid value depends on the command.

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
Y2C_OPTION_SYMBOL="|"
Y2C_FLAG_GROUP_CONCAT_SYMBOL=","
Y2C_VARIABLE_SYMBOL='<'

declare -i Y2C_YARN_WORD_IS_ORDER=1
declare -i Y2C_YARN_WORD_IS_OPTION=2
declare -i Y2C_YARN_WORD_IS_VARIABLE=3

declare -i Y2C_FUNC_ARG_IS_STR=0
declare -i Y2C_FUNC_ARG_IS_ARR=1

declare -a Y2C_TMP_IDENTIFIED_TOKENS=()
declare -a Y2C_TMP_OPTIONS=()

Y2C_TMP_EXPANDED_VAR_RESULT=

IS_SUPPORT_DECLARE_N_FLAG=1
IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT=1

declare -i Y2C_IS_YARN_2_REPO=0
declare -i Y2C_SETUP_HIT_CACHE=0

Y2C_YARN_VERSION=
Y2C_YARN_BASE64_VERSION=
Y2C_CURRENT_ROOT_REPO_PATH=
Y2C_CURRENT_ROOT_REPO_BASE64_PATH=
Y2C_VERBOSE=0

is_verbose_output() {
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

  if [[ -f "${root_repo_path}/yarn.lock" ]]; then
    Y2C_CURRENT_ROOT_REPO_PATH="${root_repo_path}"
    Y2C_CURRENT_ROOT_REPO_BASE64_PATH=$(y2c_get_var_name "${Y2C_CURRENT_ROOT_REPO_PATH}")
    yarn_version_var_name="${Y2C_REPO_ROOT_YARN_VERSION_VAR_NAME_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"
    yarn_base64_version_var_name="${Y2C_REPO_ROOT_YARN_BASE64_VERSION_VAR_NAME_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"
    is_yarn_2_var_name="${Y2C_REPO_ROOT_IS_YARN_2_VAR_NAME_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}"

    if [[ -n ${!yarn_version_var_name} ]]; then
      is_verbose_output && echo "[Y2C] Found the cache, restoring it" 1>&2

      Y2C_YARN_VERSION="${!yarn_version_var_name}"
      Y2C_IS_YARN_2_REPO=${!is_yarn_2_var_name}
      Y2C_YARN_BASE64_VERSION="${!yarn_base64_version_var_name}"
      # shellcheck disable=SC2034
      [[ $Y2C_TESTING_MODE -eq 1 ]] && Y2C_SETUP_HIT_CACHE=1

    elif command -v yarn >/dev/null 2>&1; then
      is_verbose_output && echo "[Y2C] Found the repository hosted by yarn" 1>&2

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
    else
      is_verbose_output && echo "[Y2C] yarn-2-completion won't run on this repository(yarn 2+ is required)" 1>&2
    fi

    return 0
  elif [[ -z $1 ]] && [[ -f "./package.json" ]] && ! [[ $PWD = "${Y2C_CURRENT_ROOT_REPO_PATH}"* ]]; then
    checking_path="${PWD}"
    while [[ -n $checking_path ]]; do
      checking_path="${checking_path%/*}"
      available_paths+=("${checking_path}")
    done

    # shellcheck disable=SC2015
    [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || {
      subscript=${#available_paths[@]}
      : $((subscript--))
    }
    unset "available_paths[$subscript]"

    for checking_path in "${available_paths[@]}"; do
      if y2c_setup "${checking_path}"; then
        return 0
      fi
    done

    return 1
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
    is_verbose_output && echo "[Y2C] Found the cache of workspace packges" 1>&2
    return 0
  fi

  is_verbose_output && echo "[Y2C] Finding all the workspace's packages and cache them" 1>&2

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

  set_package_name_path_map "package_names[@]" "existed_package_paths[@]"
}

expand_workspaceName_variable() {
  local var_name=""

  var_name="${Y2C_WORKSPACE_PACKAGES_PREFIX}${Y2C_CURRENT_ROOT_REPO_BASE64_PATH}[@]"
  Y2C_TMP_EXPANDED_VAR_RESULT=("${!var_name}")
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

  function_name="expand_${var_name#$Y2C_VARIABLE_SYMBOL}_variable"

  if declare -f "${function_name}" >/dev/null 2>&1; then
    $function_name "$@"
  else
    Y2C_TMP_EXPANDED_VAR_RESULT=("${var_name#$Y2C_VARIABLE_SYMBOL}")
  fi
}

get_yarn_command_tokens_var_name() {
  local base64_yarn_version="$1"
  local index="$2"
  echo "${Y2C_COMMAND_TOKENS_VARNAME_PREFIX}${base64_yarn_version}_${index}"
}

expand_yarn_workspace_command_list() {
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
    is_verbose_output && echo "[Y2C] Found the cache of yarn commands of verson ${Y2C_YARN_VERSION}" 1>&2
    return 0
  fi

  is_verbose_output && echo "[Y2C] Creating yarn commands of version ${Y2C_YARN_VERSION} for speeding up completion" 1>&2

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

  local assembling_option=""
  local yarn_command_broken_words=()
  local yarn_command_words=()
  local store_yarn_command_var_name=""
  local broken_word=""
  local yarn_command_workspace_var_name=""
  local subscript
  local instructions=()

  local flags=()

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

      broken_word=${broken_word//,/$Y2C_OPTION_SYMBOL}

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
            [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || {
              subscript=${#yarn_command_words[@]}
              : $((subscript--))
            }
            yarn_command_words[subscript]+="${Y2C_FLAG_GROUP_CONCAT_SYMBOL}${assembling_option}"

          else
            yarn_command_words+=("${assembling_option}")
          fi

          previous_word_is_option=$word_is_option
          assembling_option=
        fi
      else
        if [[ $previous_word_is_option -eq 1 ]]; then
          # shellcheck disable=SC2015
          [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || {
            subscript=${#yarn_command_words[@]}
            : $((subscript--))
          }

          IFS=',' read -r -a flags <<<"${yarn_command_words[subscript]}"

          for ((i = 0; i < ${#flags[@]}; ++i)); do
            # shellcheck disable=SC2015
            [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || {
              subscript=${#yarn_command_words[@]}
              : $((subscript--))
            }
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

    store_yarn_command_var_name="$(get_yarn_command_tokens_var_name "${Y2C_YARN_BASE64_VERSION}" "${store_yarn_command_index}")"
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

  expand_yarn_workspace_command_list "${yarn_command_workspace_var_name}" "${yarn_command_tokens_list_var_name}" "${base64_yarn_version}"
}

y2c_get_identified_token() {
  local token="$1"

  if [[ $token = \[* ]]; then
    token="${token#[}"
    IFS="${Y2C_FLAG_GROUP_CONCAT_SYMBOL}" read -r -a Y2C_TMP_IDENTIFIED_TOKENS <<<"$token"

    return $Y2C_YARN_WORD_IS_OPTION
  elif [[ $token = \<* ]]; then
    Y2C_TMP_IDENTIFIED_TOKENS=("${token}")
    return $Y2C_YARN_WORD_IS_VARIABLE
  else
    Y2C_TMP_IDENTIFIED_TOKENS=("${token}")
    return $Y2C_YARN_WORD_IS_ORDER
  fi
}

y2c_set_yarn_options() {
  local token="$1"

  IFS="${Y2C_OPTION_SYMBOL}" read -r -a Y2C_TMP_OPTIONS <<<"$token"
}

add_word_to_comreply() {
  local processing_word="$1"
  local completing_word="$2"
  local current_command="${COMP_WORDS[*]}"

  if ! [[ " ${current_command} " = *" ${processing_word} "* ]] &&
    [[ ${processing_word} = "${completing_word}"* ]] &&
    ! [[ " ${COMPREPLY[*]} " = *" ${processing_word} "* ]]; then
    COMPREPLY+=("${processing_word}")
  fi
}

y2c_add_word_candidates() {
  local token="$1"
  local completing_word="$2"

  local current_command="${COMP_WORDS[*]}"
  local token_type
  local processing_token
  local copied_identified_tokens
  local copied_options
  local option
  local option_remaining_chars

  y2c_get_identified_token "${token}"
  token_type=$?

  copied_identified_tokens=("${Y2C_TMP_IDENTIFIED_TOKENS[@]}")

  for processing_token in "${copied_identified_tokens[@]}"; do

    case "$token_type" in
    "$Y2C_YARN_WORD_IS_ORDER")
      add_word_to_comreply "${processing_token}" "${completing_word}"
      ;;
    "$Y2C_YARN_WORD_IS_OPTION")
      y2c_set_yarn_options "${processing_token}"
      copied_options=("${Y2C_TMP_OPTIONS[@]}")

      for option in "${copied_options[@]}"; do
        if [[ $current_command = *" $option"* ]]; then
          continue 2
        fi
      done

      if [[ -z $completing_word ]]; then
        COMPREPLY+=("${copied_options[@]}")
      else
        for option in "${copied_options[@]}"; do
          option_remaining_chars="${option#$completing_word}"
          if ! [[ ${option} = "$option_remaining_chars" ]]; then
            COMPREPLY+=("${option}")
          fi
        done
      fi
      ;;
    "$Y2C_YARN_WORD_IS_VARIABLE")
      y2c_set_expand_var "${processing_token}" "${completing_word}"

      for expanded_var in "${Y2C_TMP_EXPANDED_VAR_RESULT[@]}"; do
        add_word_to_comreply "${expanded_var}" "${completing_word}"
      done
      ;;
    esac
  done
}

y2c_run_yarn_completion() {
  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_tokens
  else
    local yarn_command_tokens
  fi

  local completing_word="$1"
  local word_num="${#COMP_WORDS[@]}"
  local last_word_index=$((--word_num))
  local expanded_var
  local token_type
  local processing_token
  local copied_identified_tokens=()
  local option=""
  local added_words=()

  declare -i comp_word_index=0

  COMPREPLY=()

  yarn_command_tokens_list_var_name="${Y2C_COMMAND_TOKENS_LIST_VERSION_REF_PREFIX}${Y2C_YARN_BASE64_VERSION}"

  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_tokens_list="${yarn_command_tokens_list_var_name}"
  else
    local yarn_command_tokens_list_name="${yarn_command_tokens_list_var_name}[@]"
    local yarn_command_tokens_list=("${!yarn_command_tokens_list_name}")
  fi

  for yarn_command_tokens in "${yarn_command_tokens_list[@]}"; do
    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 0 ]]; then
      yarn_command_tokens+="[@]"
      yarn_command_tokens=("${!yarn_command_tokens}")
    fi

    for ((comp_word_index = 0; comp_word_index < last_word_index; ++comp_word_index)); do
      y2c_get_identified_token "${yarn_command_tokens[$comp_word_index]}"
      token_type=$?

      copied_identified_tokens=("${Y2C_TMP_IDENTIFIED_TOKENS[@]}")

      for processing_token in "${copied_identified_tokens[@]}"; do
        case "$token_type" in
        "$Y2C_YARN_WORD_IS_ORDER")
          if [[ ${COMP_WORDS[$comp_word_index]} = "${processing_token}" ]]; then
            continue 2
          fi
          ;;
        "$Y2C_YARN_WORD_IS_OPTION")
          y2c_set_yarn_options "${processing_token}"
          for option in "${Y2C_TMP_OPTIONS[@]}"; do
            if [[ ${COMP_WORDS[$comp_word_index]} = "${option}" ]]; then
              continue 3
            fi
          done
          ;;
        "$Y2C_YARN_WORD_IS_VARIABLE")
          y2c_set_expand_var "${processing_token}" "${completing_word}"

          for expanded_var in "${Y2C_TMP_EXPANDED_VAR_RESULT[@]}"; do
            if [[ ${COMP_WORDS[$comp_word_index]} = "${expanded_var}" ]]; then
              continue 3
            fi
          done
          ;;
        esac
      done

      continue 2
    done

    if [[ " ${added_words[*]} " = *" ${yarn_command_tokens[$last_word_index]} "* ]]; then
      continue
    fi
    added_words+=("${yarn_command_tokens[$last_word_index]}")
    y2c_add_word_candidates "${yarn_command_tokens[$last_word_index]}" "${completing_word}"
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

set_package_name_path_map() {
  local package_names_ref="$1"
  local package_paths=("${!2}")
  local var_names_for_package_names=()

  # shellcheck disable=SC2207
  var_names_for_package_names=($(y2c_get_var_name "${package_names_ref}" "${Y2C_PACKAGE_NAME_PATH_PREFIX}" $Y2C_FUNC_ARG_IS_ARR))

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
