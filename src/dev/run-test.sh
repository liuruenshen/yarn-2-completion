#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/../utilities/docker.sh"

set -e

run_test_in_docker() {
  shift 1
  local docker_tag="$1"
  shift 1
  shift 1

  local coverage_subfolder="${coverage_path}/${docker_tag##*:}"
  coverage_subfolders+=("${coverage_subfolder}")

  echo "Running test on ${docker_tag}"
  # shellcheck disable=SC2140
  docker run -t --rm -v "${host_repo_root_path}":"${guest_repo_root_path}" \
    -v "${PWD}/${residing_path}/../../test/yarn-repo":"/yarn-repo" \
    "${docker_tag}" shellspec --chdir "${guest_repo_root_path}" --require yarn_command_mock \
    --shell bash --execdir @project --covdir "${coverage_subfolder}" --kcov \
    --kcov-options "--include-pattern=/src/" "$@"
}

get_last_docker_tag() {
  shift 1
  last_docker_tag="$1"
}

main() {
  local coverage_subfolders=()
  local residing_path=""
  local last_docker_tag=""
  local coverage_path="./coverage"
  local host_repo_root_path=""
  local guest_repo_root_path="/yarn-2-completion"
  local last_docker_tag_image=""

  docker_iterate get_last_docker_tag

  if [[ -z $last_docker_tag ]]; then
    echo "The value of variable last_docker_tag must not be empty; running tests failed" 1>&2
    exit 1
  fi

  last_docker_tag_image=$(get_docker_image_id "${last_docker_tag}")
  if [[ -z $last_docker_tag_image ]]; then
    echo "There is no docker image being tagged with the name $last_docker_tag; running tests failed" 1>&2
    exit 1
  fi

  residing_path="$(dirname "${BASH_SOURCE[0]}")"
  host_repo_root_path="${PWD}/${residing_path}/../../"

  # Remove the last coverage reports
  docker run --rm -v "${host_repo_root_path}":"${guest_repo_root_path}" \
    --workdir "${guest_repo_root_path}" \
    "${last_docker_tag}" bash -c "rm -rf ${coverage_path}/*"

  docker_iterate "run_test_in_docker" "$@"

  # Merge all the coverage reports produced in each bash version into a single piece.
  # shellcheck disable=SC2140
  docker run --rm -v "${host_repo_root_path}":"${guest_repo_root_path}" \
    --workdir "${guest_repo_root_path}" \
    "${last_docker_tag}" kcov --merge "${coverage_path}/merged" "${coverage_subfolders[@]}"

  # Apply the current host's UID and GID to all the items beneath the coverage folder
  docker run --rm -v "${host_repo_root_path}":"${guest_repo_root_path}" \
    --workdir "${guest_repo_root_path}" \
    "${last_docker_tag}" bash -c "adduser -D -H -u '${UID}' user_${UID}; \
      chown -R 'user_${UID}':'user_${UID}' '${coverage_path}'"
}

main "$@"
