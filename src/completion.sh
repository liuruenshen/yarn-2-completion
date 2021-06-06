#!/usr/bin/env bash

YC_COMMAND_WORDS_VARNAME_PREFIX="YARN_COMMAND_WORDS_"
YC_COMMAND_END_MARK="yarn_command_end_mark_for_prorcesing_last_word"
YC_ALTRENATIVE_FLAG_SYMBOL="|"
YC_FLAG_GROUP_CONCAT_SYMBOL=","
YC_VARIABLE_SYMBOL='<'
YC_ROOT_PACKAGE_PATH="./package.json"
YC_YARN_WORD_IS_TOKEN=1
YC_YARN_WORD_IS_FLAG=2
YC_YARN_WORD_IS_VARIABLE=3

declare -a YC_TMP_IDENTIFIED_WORDS=()
declare -a CURRENT_YARN_ALTERNATIVE_FLAGS=()
declare -a YARN_COMMAND_WORDS_REFS=()

YC_WORKSPACE_PACKAGES=
YC_TMP_EXPANDED_VAR_RESULT=

get_yarn_workspace_packages() {
  local package_json_path
  local node_commands
  local package_names
  local package_name
  local packages_path

  if ! [[ -f "${YC_ROOT_PACKAGE_PATH}" ]]; then
    return 0
  fi

  packages_path=($(node -e "console.log(require('${YC_ROOT_PACKAGE_PATH}').workspaces.join(' '))"))

  for package_path in "${packages_path[@]}"; do
    package_json_path="./${package_path}/package.json"

    if [[ -f "${package_json_path}" ]]; then
      node_commands+="console.log(require('$package_json_path').name);"
    fi
  done

  YC_WORKSPACE_PACKAGES=$(node -e "${node_commands}")

  package_names=($YC_WORKSPACE_PACKAGES)

  for index in $(seq "-${#package_names[@]}" -1); do
    set_package_name_path_map "${package_names[$index]}" "${packages_path[$index]}"
  done
}

expand_workspaceName_variable() {
  YC_TMP_EXPANDED_VAR_RESULT="$YC_WORKSPACE_PACKAGES"
}

expand_commandName_variable() {
  local package_name="$1"

  local package_path_var_name

  package_path_var_name=$(get_var_name_for_package_name "${package_name}")

  declare -n package_path_ref="${package_path_var_name}"

  if [[ -f "${package_path_ref}" ]]; then
    :
  fi
}

yc_get_expand_var() {
  local var_name="$1"
  local var_name_func_name=""
  
  shift 1

  YC_TMP_EXPANDED_VAR_RESULT=""
  
  if ! [[ $var_name = "$YC_VARIABLE_SYMBOL"* ]]; then
    YC_TMP_EXPANDED_VAR_RESULT="${var_name}"
    return 0
  fi

  var_name_func_name="expand_${var_name#$YC_VARIABLE_SYMBOL}_variable"

  if declare -f "${var_name_func_name}" > /dev/null 2>&1; then
    $var_name_func_name "$@"
  else
    YC_TMP_EXPANDED_VAR_RESULT="${var_name}"
  fi
}

expand_yarn_workspace_command_list() {
  declare -n yarn_command_workspace_ref="$1"
  declare -i store_yarn_command_index=$2
  declare -n yarn_command_words_ref
  
  local word
  local workspace_recursive_command
  local store_yarn_command_var_name
  local appending_words

  for yarn_command_words_ref in "${YARN_COMMAND_WORDS_REFS[@]}"; do
    if [[ ${yarn_command_words_ref[*]} = "yarn workspace"* ]] || \
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

    store_yarn_command_var_name="${YC_COMMAND_WORDS_VARNAME_PREFIX}${store_yarn_command_index}"
    store_yarn_command_index+=1

    declare -n store_yarn_command_ref="${store_yarn_command_var_name}"

    YARN_COMMAND_WORDS_REFS[${#YARN_COMMAND_WORDS_REFS[@]}]="${store_yarn_command_var_name}"
    store_yarn_command_ref=("${workspace_recursive_command[@]}")
  done
}

generate_yarn_command_list() {
  declare -i word_is_flag=0
  declare -i previous_word_is_flag=0
  declare -i store_yarn_command_index=0

  local ORI_IFS="${IFS}"
  local assembling_flag=""
  local yarn_command_broken_words
  local yarn_command_words
  local flags_num=0
  local store_yarn_command_var_name
  local broken_word=""
  local yarn_command_workspace_ref

  local flags=()

  IFS=$'\n'
  for instruction in $(yarn --help | grep -E '^[[:space:]]+yarn'); do
    previous_word_is_flag=0

    IFS="${ORI_IFS}"
    instruction+=" ${YC_COMMAND_END_MARK}"
    yarn_command_broken_words=($instruction)

    yarn_command_words=()

    for broken_word in "${yarn_command_broken_words[@]}"; do
      if [[ $broken_word = \[* ]] || [[ -n $assembling_flag ]]; then
        word_is_flag=1
      else 
        word_is_flag=0
      fi

      broken_word=${broken_word//,/$YC_ALTRENATIVE_FLAG_SYMBOL}

      if [[ word_is_flag -eq 1 ]]; then
        if [[ $previous_word_is_flag -eq 1 ]]; then
          broken_word="${broken_word#[}"
        fi

        if [[ -n $assembling_flag ]]; then
          assembling_flag+=" ${broken_word}"
        else
          assembling_flag="${broken_word}"
        fi

        if [[ $broken_word = *\] ]]; then
          assembling_flag="${assembling_flag%]}"
          assembling_flag="${assembling_flag%>}"

          if [[ $previous_word_is_flag -eq 1 ]]; then
            yarn_command_words[-1]+="${YC_FLAG_GROUP_CONCAT_SYMBOL}${assembling_flag}"
      
          else
            yarn_command_words+=("${assembling_flag}")
          fi

          previous_word_is_flag=$word_is_flag
          assembling_flag=
        fi
      else
        if [[ $previous_word_is_flag -eq 1 ]]; then
          IFS=','
          flags=("${yarn_command_words[-1]}")
          IFS="$ORI_IFS"

          for (( i=0; i<${#flags[@]}; ++i )); do
            yarn_command_words+=("${yarn_command_words[-1]}")
          done
        fi

        if ! [[ $broken_word = "$YC_COMMAND_END_MARK" ]]; then
          broken_word="${broken_word%]}"
          broken_word="${broken_word%>}"

          yarn_command_words+=("${broken_word}")
          previous_word_is_flag=$word_is_flag
        fi
      fi
    done

    store_yarn_command_var_name="${YC_COMMAND_WORDS_VARNAME_PREFIX}${store_yarn_command_index}"
    store_yarn_command_index+=1

    declare -n store_yarn_command_ref="${store_yarn_command_var_name}"

    YARN_COMMAND_WORDS_REFS[${#YARN_COMMAND_WORDS_REFS[@]}]="${store_yarn_command_var_name}"
    store_yarn_command_ref=("${yarn_command_words[@]}")

    if [[ $instruction = *"yarn workspace "* ]]; then
      yarn_command_workspace_ref="${store_yarn_command_var_name}"
    fi
  done

  expand_yarn_workspace_command_list "$yarn_command_workspace_ref" $store_yarn_command_index
}

yc_get_identified_word() {
  local token="$1"
  local ORI_IFS="${IFS}"

  if [[ $token = \[* ]]; then
    token="${token#[}"
    IFS="${YC_FLAG_GROUP_CONCAT_SYMBOL}"
    YC_TMP_IDENTIFIED_WORDS=($token)
    IFS="${ORI_IFS}"

    return $YC_YARN_WORD_IS_FLAG
  elif [[ $token = \<* ]]; then
    YC_TMP_IDENTIFIED_WORDS=("${token}")
    return $YC_YARN_WORD_IS_VARIABLE
  else
    YC_TMP_IDENTIFIED_WORDS=("${token}")
    return $YC_YARN_WORD_IS_TOKEN
  fi
}

set_yarn_alternative_flags() {
  local token="$1"
  local ORI_IFS="${IFS}"

  IFS="${YC_ALTRENATIVE_FLAG_SYMBOL}"
  CURRENT_YARN_ALTERNATIVE_FLAGS=($token)
  IFS="$ORI_IFS"
}

add_word_to_comreply() {
  local processing_word="$1"
  local completing_word="$2"
  local current_command="${COMP_WORDS[*]}"

  if ! [[ $current_command = *"$processing_word"* ]] && \
    [[ ${processing_word} = "${completing_word}"* ]] && \
    ! [[ ${COMPREPLY[*]}" " = *"$processing_word "* ]]; then 
    COMPREPLY+=("${processing_word}")
  fi
}

yc_add_word_candidates() {
  declare -i yarn_command_words_index=$1
  local completing_word="$2"

  local current_command="${COMP_WORDS[*]}"
  local word_type
  local processing_word
  local copied_identified_words
  local copied_flags
  local flag
  local flag_remaining_chars

  yc_get_identified_word "${yarn_command_words[$yarn_command_words_index]}"
  word_type=$?

  copied_identified_words=("${YC_TMP_IDENTIFIED_WORDS[@]}")

  for processing_word in "${copied_identified_words[@]}"; do

    case "$word_type" in
      "$YC_YARN_WORD_IS_TOKEN")
        add_word_to_comreply "${processing_word}" "${completing_word}"
        ;;
      "$YC_YARN_WORD_IS_FLAG")
        set_yarn_alternative_flags "${processing_word}"
        copied_flags=("${CURRENT_YARN_ALTERNATIVE_FLAGS[@]}")

        for flag in "${copied_flags[@]}"; do
          if [[ $current_command = *" $flag"* ]]; then
            continue 2;
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
      "$YC_YARN_WORD_IS_VARIABLE")
        yc_get_expand_var "${processing_word}" "${completing_word}"
        expanded_vars=(${YC_TMP_EXPANDED_VAR_RESULT})

        for expanded_var in "${expanded_vars[@]}"; do
          add_word_to_comreply "${expanded_var}" "${completing_word}";
        done          
        ;;
    esac
  done
}

yc_run_yarn_completion() {
  declare -n yarn_command_words

  local completing_word="$1"
  local word_num="${#COMP_WORDS[@]}"
  local last_word_index=$(( --word_num ))
  local preceding_word_index=$(( last_word_index - 1 ))
  local expanded_vars=()
  local expanded_var
  local word_type
  local processing_word
  local copied_identified_words=()

  COMPREPLY=()

  for yarn_command_words in "${YARN_COMMAND_WORDS_REFS[@]}"; do

    for (( comp_word_index=0; comp_word_index<$last_word_index; ++comp_word_index )); do
      yc_get_identified_word "${yarn_command_words[$comp_word_index]}"
      word_type=$?

      copied_identified_words=("${YC_TMP_IDENTIFIED_WORDS[@]}")

      for processing_word in "${copied_identified_words[@]}"; do
        case "$word_type" in
          "$YC_YARN_WORD_IS_TOKEN")
            if [[ ${COMP_WORDS[$comp_word_index]} = "${processing_word}" ]]; then
              continue 2
            fi
            ;;
          "$YC_YARN_WORD_IS_FLAG")
            set_yarn_alternative_flags "${processing_word}"
            for flag in "${CURRENT_YARN_ALTERNATIVE_FLAGS[@]}"; do
              if [[ ${COMP_WORDS[$comp_word_index]} = "${flag}" ]]; then
                continue 3
              fi
            done
            ;;
          "$YC_YARN_WORD_IS_VARIABLE")
            yc_get_expand_var "${processing_word}" "${completing_word}"
            expanded_vars=(${YC_TMP_EXPANDED_VAR_RESULT})
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

    yc_add_word_candidates $last_word_index "${completing_word}"
  done

  return 0
}

yc_yarn_completion_for_complete() {
  yc_run_yarn_completion "$2"
}

get_var_name_for_package_name() {
  local data
  data=$(echo "$1" | base64)
  echo ${data//=/_}
}

set_package_name_path_map() {
  local package_name="$1"
  local package_path="$2"
  local var_name_for_package_name

  var_name_for_package_name=$(get_var_name_for_package_name "$package_name")
  declare -n package_name_path_ref="$var_name_for_package_name"
  package_name_path_ref="$package_path"
}

dcard_yarn_completion_main() {
  if [ -z "$BASH_VERSINFO" ]; then
    echo "Sorry, the yarn completion only supports BASH" 1>&2
    return 1
  fi

  if [[ ${BASH_VERSINFO[0]} -lt 3 ]]; then
    echo "The yarn completion needs BASH 3+ to function properly" 1>&2
    return 1
  fi

  generate_yarn_command_list
  get_yarn_workspace_packages

  complete -D -F yc_yarn_completion_for_complete -o bashdefault -o default yarn
}

dcard_yarn_completion_main
