#!/usr/bin/env bash

list_all_files() {
  local path="$1"
  local pattern="${2:-*}"
  for item in "$path"/*; do
    # shellcheck disable=SC2053
    if [[ -f $item ]] && [[ $item = $pattern ]]; then
      echo "$item"
    elif [[ -d $item ]]; then
      list_all_files "$item"
    fi
  done
}
