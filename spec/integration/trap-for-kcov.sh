#!/usr/bin/env bash

if [[ -n $KCOV_BASH_XTRACEFD ]] && [[ ${BASH_VERSINFO[0]} -eq 5 ]]; then
  write_hit_line_to_kcov() {
    echo "kcov@${BASH_SOURCE[1]}@${BASH_LINENO[0]}@" >&$KCOV_BASH_XTRACEFD
  }

  set -o functrace
  trap write_hit_line_to_kcov "DEBUG"
fi
