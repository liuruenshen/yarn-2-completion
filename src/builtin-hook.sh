#!/usr/bin/env bash

# shellcheck disable=SC1091
. "$(dirname "${BASH_SOURCE[0]}")/feature-detector.sh"

Y2C_CURRENT_PWD=""

y2c_run_setup_if_pwd_changed() {
  if ! [[ $Y2C_CURRENT_PWD = "${PWD}" ]]; then
    Y2C_CURRENT_PWD="${PWD}"
    y2c_setup
  fi
}

y2c_install_hooks() {
  local prompt_command_attributes
  declare -i prompt_command_unset=0

  prompt_command_attributes=$(declare -p PROMPT_COMMAND 2>/dev/null) || prompt_command_unset=1

  if [[ $prompt_command_unset -eq 1 ]]; then
    PROMPT_COMMAND="y2c_run_setup_if_pwd_changed"
  elif [[ $prompt_command_attributes = *"declare -a"* ]]; then
    PROMPT_COMMAND+=("y2c_run_setup_if_pwd_changed")
  elif [[ -z "${PROMPT_COMMAND[*]}" ]]; then
    PROMPT_COMMAND="y2c_run_setup_if_pwd_changed"
  else
    PROMPT_COMMAND+=$'\n'"y2c_run_setup_if_pwd_changed"
  fi
}
