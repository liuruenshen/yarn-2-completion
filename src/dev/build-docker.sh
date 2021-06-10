#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../utilities/docker.sh"

main() {
  local script_dir=""

  script_dir=$(dirname "${BASH_SOURCE[0]}")

  local docker_files=("${script_dir}"/../../docker/*)
  local docker_file=""
  local docker_tag_name=""
  local docker_image_id=""

  for docker_file in "${docker_files[@]}"; do
    docker_tag_name=$(get_docker_tag "${docker_file}")
    docker_image_id=$(get_docker_image_id "${docker_tag_name}")

    if [[ -z $docker_image_id ]]; then
      build_docker "${docker_file}" "${docker_tag_name}"
    fi
  done
}

main
