#!/usr/bin/env bash

build_docker() {
  local docker_file="$1"
  local tag="$2"

  docker build -t "${tag}" -f "${docker_file}" .
}

get_docker_image_id() {
  local tag="$1"

  docker images "${tag}" -q
}

main() {
  local script_dir=""

  script_dir=$(dirname "${BASH_SOURCE[0]}")

  local docker_files=("${script_dir}"/../../docker/*)
  local docker_file=""
  local docker_file_name=""
  local docker_tag_name=""
  local docker_image_id=""

  for docker_file in "${docker_files[@]}"; do
    docker_file_name=$(basename "${docker_file}")
    docker_tag_name="yarn-2-completion-test:${docker_file_name%%.*}"
    docker_image_id=$(get_docker_image_id "${docker_tag_name}")

    if [[ -z $docker_image_id ]]; then
      build_docker "${docker_file}" "${docker_tag_name}"
    fi
  done
}

main
