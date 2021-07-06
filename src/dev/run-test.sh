#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../utilities/docker.sh"

set -e

run_test_in_docker() {
  shift 1
  local docker_tag="$1"
  shift 1
  shift 1

  local residing_path=""

  residing_path="$(dirname "${BASH_SOURCE[0]}")"

  echo "Running test on ${docker_tag}"
  # shellcheck disable=SC2140
  docker run -t --rm -v "${PWD}/${residing_path}/../../":"/yarn-2-completion" \
    -v "${PWD}/${residing_path}/../../test/yarn-repo":"/yarn-repo" \
    "${docker_tag}" shellspec --chdir /yarn-2-completion --require yarn_command_mock \
    --shell bash --execdir @project --covdir ./coverage --kcov "$@"
}

main() {
  docker_iterate "run_test_in_docker" "$@"
}

main "$@"
