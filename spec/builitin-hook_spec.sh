#!/usr/bin/env bash

Describe "builtin-hook.sh"
  Include "./src/builtin-hook.sh"

  It "should works well on running y2c_run_setup_if_pwd_changed"
    y2c_setup_has_been_called=0

    y2c_setup() {
      # shellcheck disable=SC2034
      y2c_setup_has_been_called=1
    }

    When call y2c_run_setup_if_pwd_changed
    The variable y2c_setup_has_been_called should equal 1
    The variable Y2C_CURRENT_PWD should equal "${PWD}"
  End
End
