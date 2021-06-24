#!/usr/bin/env bash

get_root_repo_path() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

install_on_linux() {
  local bashrc_path="${HOME}/.bashrc"
  local timestamp
  local root_repo_path=""
  local bashrc_line=""
  local enable_verbose_output_answer
  local enable_exec_complete_answer

  timestamp=$(date +%s)
  if [ -z "${timestamp}" ]; then
    echo "Failed to obtain timestamp, abort." >&2
    exit 1
  fi

  root_repo_path=$(get_root_repo_path)
  if [ -z "${root_repo_path}" ]; then
    echo "Failed to get the repository's root path where install.sh located, abort." >&2
    exit 1
  fi

  { while read -r bashrc_line; do
    if [[ "${bashrc_line}" =~ ^[[:space:]]*\.[[:space:]]${root_repo_path}/src/completion\.sh ]]; then
      echo "Yarn-2-completion has already installed."
      exit 0
    fi
  done; } <"${bashrc_path}"

  if [[ -f "${bashrc_path}" ]]; then
    cp "${bashrc_path}" "${bashrc_path}.${timestamp}.bak"
  fi

  echo "Type in your answer y(yes), n(no) or leave it empty to accept the default setting"$'\n'
  read -r -p "Do you want to enable verbose output? (y/n, default: no): " enable_verbose_output_answer
  read -r -p "Do you want the yarn-2-competion complete \"yarn exec\" for you? (y/n, default: yes): " enable_exec_complete_answer

  if [[ $enable_verbose_output_answer == 'y' ]]; then
    enable_verbose_output_answer=1
  fi

  if [[ $enable_exec_complete_answer == 'n' ]]; then
    enable_exec_complete_answer=0
  fi

  cat <<END >>"${HOME}/.bashrc"
# Beginning of yarn-2-completion's configurations
. ${root_repo_path}/src/completion.sh
export Y2C_VERBOSE=${enable_verbose_output_answer:-0}
export Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=${enable_exec_complete_answer:-1}
# End of yarn-2-completion's configurations
END

  echo "Install successfully. Open the new terminal or execute \"exec \$SHELL\" to activate yarn-2-completion." \
    $'\n'"The original .bashrc has been backed up to ${bashrc_path}.${timestamp}.bak"
}

main() {
  case "${OSTYPE}" in
  *linux*)
    install_on_linux
    ;;

  esac
}

main
