#!/usr/bin/env bash

get_root_repo_path() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

uninstall() {
  local startup_file="$1"
  local bashrc_path="${HOME}/${startup_file}"
  local timestamp
  local root_repo_path=""
  local bashrc_line=""
  local bashrc_content=""
  local uninstalled_bashrc_content=""

  timestamp=$(date +%s)
  if [ -z "${timestamp}" ]; then
    echo "Fail to obtain the timestamp, abort." >&2
    exit 1
  fi

  root_repo_path=$(get_root_repo_path)
  if [ -z "${root_repo_path}" ]; then
    echo "Fail to get the repository's root path where uninstall.sh located, abort." >&2
    exit 1
  fi

  if ! [[ -f "${bashrc_path}" ]]; then
    echo "${bashrc_path} is not found, abort." >&2
  fi

  { while read -r bashrc_line; do
    case "${bashrc_line}" in
    *"yarn-2-completion"* | *"Y2C"* | *"${root_repo_path}/src/completion.sh"*)
      bashrc_content+="${bashrc_line}"$'\n'
      ;;
    *)
      bashrc_content+="${bashrc_line}"$'\n'
      uninstalled_bashrc_content+="${bashrc_line}"$'\n'
      ;;
    esac
  done; } <"${bashrc_path}"

  if [[ "${bashrc_content}" == "${uninstalled_bashrc_content}" ]]; then
    echo "Yarn-2-completion has already uninstalled."
    exit 0
  fi

  cp "${bashrc_path}" "${bashrc_path}.${timestamp}.bak"

  echo -n "${uninstalled_bashrc_content}" >"${bashrc_path}"

  echo "Uninstall successfully. The original ${startup_file} file has been backed up to ${bashrc_path}.${timestamp}.bak"
}

main() {
  case "${OSTYPE}" in
  darwin*)
    uninstall ".bash_profile"
    ;;
  *)
    uninstall ".bashrc"
    ;;
  esac
}

main
