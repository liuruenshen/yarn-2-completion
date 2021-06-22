#!/usr/bin/env bash

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/feature-detector.sh"

get_random_str_list() {
  declare -i item_num=$1
  declare -i index=0
  local node_command=""

  for ((index = 0; index < item_num; ++index)); do
    node_command+="console.log(Math.floor(Math.random() * 1e10).toString(36));"
  done

  node -e "${node_command}"
}

Y2C_CD_WRAPPER_PREFIX="y2c_"
Y2C_CD_FUNC_NAME=""
Y2C_PUSHD_FUNC_NAME=""
Y2C_POPD_FUNC_NAME=""

wrap_existed_cmd_func() {
  local command="$1"
  local random_str="$2"
  local func_def=""
  local var_name=""
  local func_name=""

  declare -i func_not_defined=0

  func_def=$(declare -f "${command}") || func_not_defined=1
  if [[ "${func_not_defined}" -eq 1 ]]; then
    return 0
  fi

  if [[ "${func_def}" = *"y2c_setup"* ]]; then
    return 0
  fi

  if [[ $IS_SUPPORT_UPPER_CASE_TRANSFORM -eq 1 ]]; then
    var_name="Y2C_${command^^}_FUNC_NAME"
  else
    var_name="Y2C_$(tr "[:lower:]" "[:upper:]" <<<"$command")_FUNC_NAME"
  fi

  func_name="${Y2C_CD_WRAPPER_PREFIX}${command}_${random_str}"
  func_def="${func_def/$command/$func_name}"
  eval "$var_name=\"${func_name}\""
  eval "$func_def"
}

install_hooks() {
  local func_id_list=()
  local func_id=""
  { while read -r func_id; do func_id_list+=("${func_id}"); done; } < <(get_random_str_list 3)

  feature_detector

  wrap_existed_cmd_func "cd" "${func_id_list[0]}"
  wrap_existed_cmd_func "pushd" "${func_id_list[1]}"
  wrap_existed_cmd_func "popd" "${func_id_list[2]}"

  cd() {
    if [[ -n $Y2C_CD_FUNC_NAME ]]; then
      $Y2C_CD_FUNC_NAME "$@" && y2c_setup
    else
      builtin cd "$@" && y2c_setup
    fi

    return 0
  }

  pushd() {
    if [[ -n $Y2C_PUSHD_FUNC_NAME ]]; then
      $Y2C_PUSHD_FUNC_NAME "$@" && y2c_setup
    else
      builtin pushd "$@" && y2c_setup
    fi

    return 0
  }

  popd() {
    if [[ -n $Y2C_POPD_FUNC_NAME ]]; then
      $Y2C_POPD_FUNC_NAME "$@" && y2c_setup
    else
      builtin popd "$@" && y2c_setup
    fi

    return 0
  }
}
