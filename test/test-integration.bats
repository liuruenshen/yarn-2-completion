setup_file() {
  load "test_helper/common_setup"
  _common_setup
}

setup() {
  load 'test_helper/bats-support/load'
  load 'test_helper/bats-assert/load'

  cd "$( dirname "$BATS_TEST_FILENAME" )"
}

@test "integration" {
  run env SHELL="$BASH" expect ./test-integration.tcl
  assert_output --partial "yarn info --extra test"
  [ $status -eq 0 ]
}
