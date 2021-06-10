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

get_docker_tag() {
  local docker_file="$1"
  local docker_file_name=""

  if [[ -z "$docker_file" ]] || ! [[ -f $docker_file ]]; then
    echo ""
    return 1
  fi

  docker_file_name=$(basename "${docker_file}")
  echo "yarn-2-completion-test:${docker_file_name%%.*}"
}

docker_iterate() {
  local invoke_func="$1"
  local script_dir=""

  if ! declare -f "${invoke_func}" >/dev/null 2>&1; then
    return 1
  fi

  script_dir=$(dirname "${BASH_SOURCE[0]}")

  local docker_files=("${script_dir}"/../../docker/*)
  local docker_file=""
  local docker_tag_name=""
  local docker_image_id=""

  for docker_file in "${docker_files[@]}"; do
    docker_tag_name=$(get_docker_tag "${docker_file}")
    docker_image_id=$(get_docker_image_id "${docker_tag_name}")

    $invoke_func "${docker_file}" "${docker_tag_name}" "${docker_image_id}"
  done

  return 0
}
