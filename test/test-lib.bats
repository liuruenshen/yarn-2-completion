setup_file() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    # make executables in src/ visible to PATH
    PATH="$DIR/../src:$PATH"
}

setup() {
    cd "$( dirname "$BATS_TEST_FILENAME" )/yarn-repo"
    . lib.sh
}

@test "expect the environemnt values has the correct values after running y2c_setup" {
    y2c_generate_yarn_command_list() {
        :
    }

    y2c_generate_workspace_packages() {
        :
    }

    cd test1
    y2c_detect_environment
    y2c_setup

    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3QxCg__ -eq 1 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 1 ]

    cd ../test2

    y2c_setup || true

    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3QxCg__ -eq 1 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3QyCg__ -eq 0 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 0 ]

    cd ../test1/workspace-b
    y2c_setup

    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3QxCg__ -eq 1 ]
    [ $Y2C_REPO_YARN_VERSION_L3lhcm4tMi1jb21wbGV0aW9uL3Rlc3QveWFybi1yZXBvL3Rlc3QyCg__ -eq 0 ]
    [ $Y2C_CURRENT_ROOT_REPO_PATH = "${PWD%/workspace-b}" ]
    [ $Y2C_IS_YARN_2_REPO -eq 1 ]
}
