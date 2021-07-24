source "[file dirname [file normalize [info script]]]/common.tcl"

set timeout 5
set bash_arg_str [lindex $argv 0]
set working_dir [lindex $argv 1]
set declare_prompt_command [lindex $argv 2]
set prompt "bash-.+$"

eval spawn $env(SHELL) $bash_arg_str
expect -re $prompt

send_and_expect "cd $working_dir\r"
send_and_expect "Y2C_TESTING_MODE=1\r"

send_and_expect "declare -p PROMPT_COMMAND\r" $declare_prompt_command
send_and_expect ". ./spec/integration/trap-for-kcov.sh\r"
send_and_expect ". ./src/completion.sh\r"
send_and_expect "declare -p Y2C_SETUP_HAS_BEEN_CALLED\r" "declare -- Y2C_SETUP_HAS_BEEN_CALLED=\"1\"\r"