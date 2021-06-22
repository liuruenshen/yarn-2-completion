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
  docker run --rm -v "${PWD}/${residing_path}/../":"/yarn-2-completion/src" \
    -v "${PWD}/${residing_path}/../../test":"/yarn-2-completion/test" \
    "${docker_tag}" /yarn-2-completion/test/bats/bin/bats "$@" /yarn-2-completion/test
}

main() {
  docker_iterate "run_test_in_docker" "$@"
}

main "$@"
