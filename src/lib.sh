#!/usr/bin/env bash

Y2C_COMPLETION_SCRIPT_LOCATION=$(dirname "${BASH_SOURCE[0]}")

Y2C_COMMAND_WORDS_VARNAME_PREFIX="YARN_COMMAND_WORDS_"
Y2C_COMMAND_WORDS_VERSION_REF_PREFIX="YARN_COMMAND_WORDS_VER_"

Y2C_COMMAND_END_MARK="yarn_command_end_mark_for_prorcesing_last_word"
Y2C_ALTRENATIVE_FLAG_SYMBOL="|"
Y2C_FLAG_GROUP_CONCAT_SYMBOL=","
Y2C_VARIABLE_SYMBOL='<'
Y2C_ROOT_PACKAGE_PATH="./package.json"
Y2C_YARN_WORD_IS_TOKEN=1
Y2C_YARN_WORD_IS_FLAG=2
Y2C_YARN_WORD_IS_VARIABLE=3

declare -a Y2C_TMP_IDENTIFIED_WORDS=()
declare -a CURRENT_YARN_ALTERNATIVE_FLAGS=()
declare -a YARN_COMMAND_WORDS_REFS=()

Y2C_WORKSPACE_PACKAGES=
Y2C_TMP_EXPANDED_VAR_RESULT=
Y2C_REPO_ROOT_YARN_VERSION_VAR_NAME_PREFIX="Y2C_REPO_YARN_VERSION_"

IS_SUPPORT_DECLARE_N_FLAG=1
IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT=1

Y2C_CURRENT_ROOT_REPO_PATH=

Y2C_TMP_REPO_YARN_VERSION=
Y2C_TMP_YARN_COMMAND_WORDS_VER_REF=
declare -i Y2C_IS_YARN_2_REPO=0

y2c_setup() {
  declare -i is_yarn_2=0
  declare -i subscript=0

  local root_repo_path="${1:-"$PWD"}"
  local var_name=""
  local available_paths=()
  local checking_path=""
  local yarn_version=""

  if [[ -f "${root_repo_path}/yarn.lock" ]]; then
    Y2C_CURRENT_ROOT_REPO_PATH="${root_repo_path}"
    var_name="${Y2C_REPO_ROOT_YARN_VERSION_VAR_NAME_PREFIX}"$(y2c_get_var_name "$root_repo_path")

    if [[ -n ${!var_name} ]]; then
      Y2C_IS_YARN_2_REPO=${!var_name}
    elif command -v yarn >/dev/null 2>&1; then
      y2c_is_yarn_2
      is_yarn_2=$(($? ^ 1))

      yarn_version="${Y2C_TMP_REPO_YARN_VERSION}"

      Y2C_IS_YARN_2_REPO=$is_yarn_2

      if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
        declare -n yarn_version_ref="${var_name}"
        # shellcheck disable=SC2034
        yarn_version_ref=$is_yarn_2
      else
        eval "$var_name=$is_yarn_2"
      fi
    fi

    if [[ Y2C_IS_YARN_2_REPO -eq 1 ]]; then
      y2c_generate_yarn_command_list "${yarn_version}"
      y2c_generate_workspace_packages
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

y2c_set_path_yarn_version() {
  :
}

y2c_generate_workspace_packages() {
  local package_json_path
  local node_commands
  local package_names
  local package_name
  local packages_path

  if ! [[ -f "${Y2C_ROOT_PACKAGE_PATH}" ]]; then
    return 0
  fi

  # shellcheck disable=SC2207
  packages_path=($(node -e "console.log((require('${Y2C_ROOT_PACKAGE_PATH}').workspaces || []).join(' '))"))

  for package_path in "${packages_path[@]}"; do
    package_json_path="./${package_path}/package.json"

    if [[ -f "${package_json_path}" ]]; then
      node_commands+="console.log(require('$package_json_path').name);"
    fi
  done

  # shellcheck disable=SC2207
  package_names=($(node -e "${node_commands}"))

  Y2C_WORKSPACE_PACKAGES="${package_names[*]}"

  for ((index = 0; index < ${#package_names[@]}; ++index)); do
    set_package_name_path_map "${package_names[$index]}" "${packages_path[$index]}"
  done
}

expand_workspaceName_variable() {
  Y2C_TMP_EXPANDED_VAR_RESULT="$Y2C_WORKSPACE_PACKAGES"
}

expand_commandName_variable() {
  :
}

y2c_get_expand_var() {
  local var_name="$1"
  local var_name_func_name=""

  shift 1

  Y2C_TMP_EXPANDED_VAR_RESULT=""

  if ! [[ $var_name = "$Y2C_VARIABLE_SYMBOL"* ]]; then
    Y2C_TMP_EXPANDED_VAR_RESULT="${var_name}"
    return 0
  fi

  var_name_func_name="expand_${var_name#$Y2C_VARIABLE_SYMBOL}_variable"

  if declare -f "${var_name_func_name}" >/dev/null 2>&1; then
    $var_name_func_name "$@"
  else
    Y2C_TMP_EXPANDED_VAR_RESULT="${var_name}"
  fi
}

expand_yarn_workspace_command_list() {
  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_workspace_ref="$1"
    declare -n yarn_command_words_ref
  else
    local yarn_command_workspace_ref="$1"
    local yarn_command_words_ref
  fi

  declare -i store_yarn_command_index=$2

  local word
  local workspace_recursive_command
  local store_yarn_command_var_name
  local appending_words

  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 0 ]]; then
    yarn_command_workspace_ref+="[@]"
    yarn_command_workspace_ref=("${!yarn_command_workspace_ref}")
  fi

  for yarn_command_words_ref in "${YARN_COMMAND_WORDS_REFS[@]}"; do
    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 0 ]]; then
      yarn_command_words_ref+="[@]"
      yarn_command_words_ref=("${!yarn_command_words_ref}")
    fi

    if [[ ${yarn_command_words_ref[*]} = "yarn workspace"* ]] ||
      [[ ${yarn_command_words_ref[*]} = "yarn workspaces"* ]]; then
      continue
    fi

    workspace_recursive_command=()
    for word in "${yarn_command_workspace_ref[@]}"; do
      if [[ $word = '<commandName' ]]; then
        appending_words=("${yarn_command_words_ref[@]}")
        unset "appending_words[0]"
        workspace_recursive_command+=("${appending_words[@]}")
      else
        workspace_recursive_command+=("$word")
      fi
    done

    store_yarn_command_var_name="${Y2C_COMMAND_WORDS_VARNAME_PREFIX}${store_yarn_command_index}"
    store_yarn_command_index+=1

    YARN_COMMAND_WORDS_REFS[${#YARN_COMMAND_WORDS_REFS[@]}]="${store_yarn_command_var_name}"
    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
      declare -n store_yarn_command_ref="${store_yarn_command_var_name}"
      # shellcheck disable=SC2034
      store_yarn_command_ref=("${workspace_recursive_command[@]}")
    else
      eval "$store_yarn_command_var_name=("'"''${workspace_recursive_command[@]}''"'")"
    fi
  done
}

y2c_is_yarn_2() {
  local yarn_version
  yarn_version=$(yarn --version)
  Y2C_TMP_REPO_YARN_VERSION="${yarn_version}"

  if [[ ${yarn_version%%.*} -lt 2 ]]; then
    return 1
  fi

  return 0
}

y2c_get_yarn_commands_words_var_name() {
  local yarn_version="$1"
  Y2C_TMP_YARN_COMMAND_WORDS_VER_REF="${Y2C_COMMAND_WORDS_VERSION_REF_PREFIX}$(y2c_get_var_name "${yarn_version}")"
}

y2c_generate_yarn_command_list() {
  local yarn_version="$1"

  y2c_get_yarn_commands_words_var_name "${yarn_version}"

  if [[ -n ${!Y2C_TMP_YARN_COMMAND_WORDS_VER_REF} ]]; then
    return 0
  fi

  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_words_version_ref="${Y2C_TMP_YARN_COMMAND_WORDS_VER_REF}"
    yarn_command_words_version_ref=()
  else
    eval "$Y2C_TMP_YARN_COMMAND_WORDS_VER_REF=()"
  fi

  if ! command -v yarn >/dev/null 2>&1; then
    echo "Yarn executable is not found, yarn-2-completion won't activate" 1>&2
    return 1
  fi

  declare -i word_is_flag=0
  declare -i previous_word_is_flag=0
  declare -i store_yarn_command_index=0

  local assembling_flag=""
  local yarn_command_broken_words
  local yarn_command_words
  local store_yarn_command_var_name
  local broken_word=""
  local yarn_command_workspace_ref
  local subscript
  local instructions=()

  local flags=()

  while IFS='' read -r line; do instructions+=("$line"); done <<<"$(yarn --help | grep -E '^[[:space:]]+yarn')"

  for instruction in "${instructions[@]}"; do
    previous_word_is_flag=0

    instruction+=" ${Y2C_COMMAND_END_MARK}"
    IFS=" " read -r -a yarn_command_broken_words <<<"$instruction"

    yarn_command_words=()

    for broken_word in "${yarn_command_broken_words[@]}"; do
      if [[ $broken_word = \[* ]] || [[ -n $assembling_flag ]]; then
        word_is_flag=1
      else
        word_is_flag=0
      fi

      broken_word=${broken_word//,/$Y2C_ALTRENATIVE_FLAG_SYMBOL}

      if [[ word_is_flag -eq 1 ]]; then
        if [[ $previous_word_is_flag -eq 1 ]]; then
          broken_word="${broken_word#[}"
        fi

        if [[ -n $assembling_flag ]]; then
          assembling_flag+=" ${broken_word}"
        else
          assembling_flag="${broken_word}"
        fi

        if [[ $broken_word = *$'\x5d' ]]; then
          assembling_flag="${assembling_flag%]}"
          assembling_flag="${assembling_flag%>}"

          if [[ $previous_word_is_flag -eq 1 ]]; then
            # shellcheck disable=SC2015
            [[ $IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT -eq 1 ]] && subscript=-1 || {
              subscript=${#yarn_command_words[@]}
              : $((subscript--))
            }
            yarn_command_words[subscript]+="${Y2C_FLAG_GROUP_CONCAT_SYMBOL}${assembling_flag}"

          else
            yarn_command_words+=("${assembling_flag}")
          fi

          previous_word_is_flag=$word_is_flag
          assembling_flag=
        fi
      else
        if [[ $previous_word_is_flag -eq 1 ]]; then
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
          previous_word_is_flag=$word_is_flag
        fi
      fi
    done

    store_yarn_command_var_name="${Y2C_COMMAND_WORDS_VARNAME_PREFIX}${store_yarn_command_index}"
    store_yarn_command_index+=1

    YARN_COMMAND_WORDS_REFS[${#YARN_COMMAND_WORDS_REFS[@]}]="${store_yarn_command_var_name}"

    if [[ IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
      yarn_command_words_version_ref[${#yarn_command_words_version_ref[@]}]="${store_yarn_command_var_name}"

      declare -n store_yarn_command_words_ref="${store_yarn_command_var_name}"
      # shellcheck disable=SC2034
      store_yarn_command_words_ref=("${yarn_command_words[@]}")
    else
      eval "${Y2C_TMP_YARN_COMMAND_WORDS_VER_REF}+=("'"'"${store_yarn_command_var_name}"'"'")"
      eval "$store_yarn_command_var_name=("'"''${yarn_command_words[@]}''"'")"
    fi

    if [[ $instruction = *"yarn workspace "* ]]; then
      yarn_command_workspace_ref="${store_yarn_command_var_name}"
    fi
  done

  expand_yarn_workspace_command_list "$yarn_command_workspace_ref" $store_yarn_command_index
}

y2c_get_identified_word() {
  local token="$1"

  if [[ $token = \[* ]]; then
    token="${token#[}"
    IFS="${Y2C_FLAG_GROUP_CONCAT_SYMBOL}" read -r -a Y2C_TMP_IDENTIFIED_WORDS <<<"$token"

    return $Y2C_YARN_WORD_IS_FLAG
  elif [[ $token = \<* ]]; then
    Y2C_TMP_IDENTIFIED_WORDS=("${token}")
    return $Y2C_YARN_WORD_IS_VARIABLE
  else
    Y2C_TMP_IDENTIFIED_WORDS=("${token}")
    return $Y2C_YARN_WORD_IS_TOKEN
  fi
}

set_yarn_alternative_flags() {
  local token="$1"

  IFS="${Y2C_ALTRENATIVE_FLAG_SYMBOL}" read -r -a CURRENT_YARN_ALTERNATIVE_FLAGS <<<"$token"
}

add_word_to_comreply() {
  local processing_word="$1"
  local completing_word="$2"
  local current_command="${COMP_WORDS[*]}"

  if ! [[ $current_command = *"$processing_word"* ]] &&
    [[ ${processing_word} = "${completing_word}"* ]] &&
    ! [[ ${COMPREPLY[*]}" " = *"$processing_word "* ]]; then
    COMPREPLY+=("${processing_word}")
  fi
}

y2c_add_word_candidates() {
  declare -i yarn_command_words_index=$1
  local completing_word="$2"

  local current_command="${COMP_WORDS[*]}"
  local word_type
  local processing_word
  local copied_identified_words
  local copied_flags
  local flag
  local flag_remaining_chars

  y2c_get_identified_word "${yarn_command_words[$yarn_command_words_index]}"
  word_type=$?

  copied_identified_words=("${Y2C_TMP_IDENTIFIED_WORDS[@]}")

  for processing_word in "${copied_identified_words[@]}"; do

    case "$word_type" in
    "$Y2C_YARN_WORD_IS_TOKEN")
      add_word_to_comreply "${processing_word}" "${completing_word}"
      ;;
    "$Y2C_YARN_WORD_IS_FLAG")
      set_yarn_alternative_flags "${processing_word}"
      copied_flags=("${CURRENT_YARN_ALTERNATIVE_FLAGS[@]}")

      for flag in "${copied_flags[@]}"; do
        if [[ $current_command = *" $flag"* ]]; then
          continue 2
        fi
      done

      if [[ -z $completing_word ]]; then
        COMPREPLY+=("${copied_flags[@]}")
      else
        for flag in "${copied_flags[@]}"; do
          flag_remaining_chars="${flag#$completing_word}"
          if ! [[ ${flag} = "$flag_remaining_chars" ]]; then
            COMPREPLY+=("${flag}")
          fi
        done
      fi
      ;;
    "$Y2C_YARN_WORD_IS_VARIABLE")
      y2c_get_expand_var "${processing_word}" "${completing_word}"

      IFS=" " read -r -a expanded_vars <<<"$Y2C_TMP_EXPANDED_VAR_RESULT"

      for expanded_var in "${expanded_vars[@]}"; do
        add_word_to_comreply "${expanded_var}" "${completing_word}"
      done
      ;;
    esac
  done
}

y2c_run_yarn_completion() {
  if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n yarn_command_words
  else
    local yarn_command_words
  fi

  local completing_word="$1"
  local word_num="${#COMP_WORDS[@]}"
  local last_word_index=$((--word_num))
  local expanded_vars=()
  local expanded_var
  local word_type
  local processing_word
  local copied_identified_words=()

  COMPREPLY=()

  for yarn_command_words in "${YARN_COMMAND_WORDS_REFS[@]}"; do
    if [[ $IS_SUPPORT_DECLARE_N_FLAG -eq 0 ]]; then
      yarn_command_words+="[@]"
      yarn_command_words=("${!yarn_command_words}")
    fi

    for ((comp_word_index = 0; comp_word_index < last_word_index; ++comp_word_index)); do
      y2c_get_identified_word "${yarn_command_words[$comp_word_index]}"
      word_type=$?

      copied_identified_words=("${Y2C_TMP_IDENTIFIED_WORDS[@]}")

      for processing_word in "${copied_identified_words[@]}"; do
        case "$word_type" in
        "$Y2C_YARN_WORD_IS_TOKEN")
          if [[ ${COMP_WORDS[$comp_word_index]} = "${processing_word}" ]]; then
            continue 2
          fi
          ;;
        "$Y2C_YARN_WORD_IS_FLAG")
          set_yarn_alternative_flags "${processing_word}"
          for flag in "${CURRENT_YARN_ALTERNATIVE_FLAGS[@]}"; do
            if [[ ${COMP_WORDS[$comp_word_index]} = "${flag}" ]]; then
              continue 3
            fi
          done
          ;;
        "$Y2C_YARN_WORD_IS_VARIABLE")
          y2c_get_expand_var "${processing_word}" "${completing_word}"

          IFS=" " read -r -a expanded_vars <<<"$Y2C_TMP_EXPANDED_VAR_RESULT"
          for expanded_var in "${expanded_vars[@]}"; do
            if [[ ${COMP_WORDS[$comp_word_index]} = "${expanded_var}" ]]; then
              continue 3
            fi
          done
          ;;
        esac
      done

      continue 2
    done

    y2c_add_word_candidates $last_word_index "${completing_word}"
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
  local data
  data=$(echo "$1" | base64)
  echo "${data//=/_}"
}

set_package_name_path_map() {
  local package_name="$1"
  local package_path="$2"
  local var_name_for_package_name

  var_name_for_package_name=$(y2c_get_var_name "$package_name")
  if [[ IS_SUPPORT_DECLARE_N_FLAG -eq 1 ]]; then
    declare -n package_name_path_ref="$var_name_for_package_name"
    # shellcheck disable=SC2034
    package_name_path_ref="$package_path"
  else
    eval "$var_name_for_package_name="'"'"${package_path}"'"'
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
