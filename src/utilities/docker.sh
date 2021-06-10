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
