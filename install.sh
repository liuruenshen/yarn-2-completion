#!/usr/bin/env bash

get_root_repo_path() {
  cd "$(dirname "${BASH_SOURCE[0]}")" && pwd
}

install() {
  local startup_file="$1"
  local bashrc_path="${HOME}/${startup_file}"
  local timestamp
  local root_repo_path=""
  local bashrc_line=""
  local enable_verbose_output_answer
  local enable_exec_complete_answer
  declare -i has_backed_up=0

  timestamp=$(date +%s)
  if [ -z "${timestamp}" ]; then
    echo "Fail to obtain a timestamp, abort installation." >&2
    exit 1
  fi

  root_repo_path=$(get_root_repo_path)
  if [ -z "${root_repo_path}" ]; then
    echo "Fail to get the repository's root path where install.sh located, abort installation." >&2
    exit 1
  fi

  if [[ -f "${bashrc_path}" ]]; then
    { while read -r bashrc_line; do
      if [[ "${bashrc_line}" =~ ^[[:space:]]*\.[[:space:]]${root_repo_path}/src/completion\.sh ]]; then
        echo "Yarn-2-completion has already installed."
        exit 0
      fi
    done; } <"${bashrc_path}"

    if ! cp "${bashrc_path}" "${bashrc_path}.${timestamp}.bak"; then
      echo "Fail to backup ${bashrc_path} to ${bashrc_path}.${timestamp}.bak, abort installation." >&2
      exit 1
    fi

    has_backed_up=1
  fi

  echo "Type in your answer y(yes), n(no), or leave it empty to accept the default setting"
  read -r -p $'\n'"Do you want to enable verbose output? (y/n, default: no): " enable_verbose_output_answer
  read -r -p $'\n'"Do you want the yarn-2-competion complete \"yarn exec\" for you? (y/n, default: yes): " enable_exec_complete_answer

  if [[ $enable_verbose_output_answer == 'y' ]]; then
    enable_verbose_output_answer=1
  else
    enable_verbose_output_answer=
  fi

  if [[ $enable_exec_complete_answer == 'n' ]]; then
    enable_exec_complete_answer=0
  else
    enable_exec_complete_answer=
  fi

  cat <<END >>"${HOME}/${startup_file}"
# Beginning of yarn-2-completion's configurations
. ${root_repo_path}/src/completion.sh
export Y2C_VERBOSE=${enable_verbose_output_answer:-0}
export Y2C_SYSTEM_EXECUTABLE_BY_PATH_ENV=${enable_exec_complete_answer:-1}
# End of yarn-2-completion's configurations
END

  echo $'\n'"Install successfully. Open the new terminal to activate yarn-2-completion."
  [[ $has_backed_up -eq 1 ]] && echo "The original ${startup_file} has been backed up to ${bashrc_path}.${timestamp}.bak"
}

main() {
  case "${OSTYPE}" in
  darwin*)
    install ".bash_profile"
    ;;
  *)
    install ".bashrc"
    ;;

  esac
}

main
