#!/usr/bin/env bash

declare -i IS_SUPPORT_DECLARE_N_FLAG=0
declare -i IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT=0
declare -i IS_SUPPORT_UPPER_CASE_TRANSFORM=0

feature_detector() {
  local script_location=""

  script_location=$(dirname "${BASH_SOURCE[0]}")

  # shellcheck disable=SC2034
  if declare -n declare_n_flag_test >/dev/null 2>&1; then
    IS_SUPPORT_DECLARE_N_FLAG=1
  fi

  if "${script_location}/syntax-checker/negative-subscript.sh" >/dev/null 2>&1; then
    # shellcheck disable=SC2034
    IS_SUPPORT_NEGATIVE_NUMBER_SUBSCRIPT=1
  fi

  if "${script_location}/syntax-checker/upper-case.sh" >/dev/null 2>&1; then
    # shellcheck disable=SC2034
    IS_SUPPORT_UPPER_CASE_TRANSFORM=1
  fi
}
