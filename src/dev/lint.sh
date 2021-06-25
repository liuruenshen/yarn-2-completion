#!/usr/bin/env bash

main() {
  set -e

  local shellcheck_image_id=""
  local residing_path=""
  local host_source_path=""
  local host_checking_items=()
  local host_checking_files=()
  local guest_source_files=()
  local guest_checking_files_root="/checking_files"

  residing_path=$(dirname "${BASH_SOURCE[0]}")

  # shellcheck disable=SC1091
  source "${residing_path}/../utilities/list-all-files.sh"

  if ! command -v docker; then
    echo "Install docker before commiting any chages" 1>&2
    exit
  fi

  shellcheck_image_id=$(docker images -q koalaman/shellcheck)
  if [[ -z $shellcheck_image_id ]]; then
    docker pull koalaman/shellcheck
  fi

  host_source_path="${PWD}/${residing_path}/../../src"

  if shopt -s globstar >/dev/null 2>&1; then
    host_checking_items=("$host_source_path"/**/*)

    for item in "${host_checking_items[@]}"; do
      if [[ -f $item ]]; then
        host_checking_files+=("${item}")
      fi
    done
  else
    #shellcheck disable=SC2207
    host_checking_files=($(list_all_files "${PWD}/${residing_path}/../../src"))
  fi

  guest_source_files=("${host_checking_files[@]/"$host_source_path"/"$guest_checking_files_root"}")

  docker run --rm -v "${host_source_path}":"${guest_checking_files_root}" koalaman/shellcheck "${guest_source_files[@]}"
}

main
