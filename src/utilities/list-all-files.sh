#!/usr/bin/env bash

list_all_files() {
  local path="$1"
  for item in "$path"/*; do
    if [[ -f $item ]]; then
      echo "$item"
    elif [[ -d $item ]]; then
      list_all_files "$item"
    fi
  done
}
