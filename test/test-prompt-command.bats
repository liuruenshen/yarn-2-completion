setup_file() {
  load "test_helper/common_setup"
  _common_setup
}

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  cd "$( dirname "$BATS_TEST_FILENAME" )"
}

teardown() {
  rm -f "${PWD}/set-prompt-command-arr.rc"
}

@test "prompt_command(prompt_command was unset in the environment)" {
  [ ! $Y2C_SETUP_HAS_BEEN_CALLED ]

  run env SHELL="$BASH" ./test-prompt-command.exp "--norc" "${PWD%/test}" ".+not found\r"
  assert_output --partial "Y2C_SETUP_HAS_BEEN_CALLED=\"1\""
  [ $status -eq 0 ]
}

@test "prompt_command(prompt_command was string in the environment)" {
  [ ! $Y2C_SETUP_HAS_BEEN_CALLED ]

  prompt_command_test1() {
    echo "prompt_command_test1 has been run by bash" > /tmp/prompt_command_test1
  }
  export -f prompt_command_test1
  export PROMPT_COMMAND="prompt_command_test1"

  run env SHELL="$BASH" ./test-prompt-command.exp "--norc" "${PWD%/test}" ".+PROMPT_COMMAND=\"prompt_command_test1\"\r"
  assert_output --partial "Y2C_SETUP_HAS_BEEN_CALLED=\"1\""

  run cat /tmp/prompt_command_test1
  assert_output "prompt_command_test1 has been run by bash"

  [ $status -eq 0 ]
}

@test "prompt_command(prompt_command was array with one element in the environment)" {
  if [ ${BASH_VERSINFO[0]} -lt 5 ] || [ ${BASH_VERSINFO[1]} -lt 1 ]; then
    skip
  fi

  [ ! $Y2C_SETUP_HAS_BEEN_CALLED ]

cat > ./set-prompt-command-arr.rc <<END
PROMPT_COMMAND=()
prompt_command_test1() {
  echo "prompt_command_test1 has been run by bash" > /tmp/prompt_command_test1
}
PROMPT_COMMAND+=("prompt_command_test1")
END

  run env SHELL="$BASH" ./test-prompt-command.exp "--rcfile \"./set-prompt-command-arr.rc\"" \
    "${PWD%/test}" ".+PROMPT_COMMAND=[']?\(\[0\]=\"prompt_command_test1\"\)[']?"
  assert_output --partial "Y2C_SETUP_HAS_BEEN_CALLED=\"1\""

  run cat /tmp/prompt_command_test1
  assert_output "prompt_command_test1 has been run by bash"


  [ $status -eq 0 ]
}
