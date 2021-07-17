source "[file dirname [file normalize [info script]]]/common.tcl"

set timeout 5
set bash_arg_str [lindex $argv 0]
set exit_status 0
eval spawn $env(SHELL) $bash_arg_str
expect -re $default_bash_prompt

set negative_acknowledge "\x15"
# https://en.wikipedia.org/wiki/ANSI_escape_code
set match_final_erase_in_line [string cat "\x1b" {\[} "\x4b" {$}]

set move_backward_a_word [string cat "\x17"]

set yarn_completion [string cat \
  "add           dedupe        explain       link          patch         remove        unplug        workspaces    \r\n" \
  "bin           dev           info          node          patch-commit  run           up            \r\n" \
  "cache         dlx           init          npm           plugin        set           why           \r\n" \
  "config        exec          install       pack          rebuild       test          workspace     \r\n"]

set yarn_add_completion [string cat \
  "--cached       --exact        --optional     --tilde        -E             -T             \r\n" \
  "--caret        --interactive  --peer         -C             -O             -i             \r\n" \
  "--dev          --json         --prefer-dev   -D             -P             ...            \r\n" \
  $default_bash_prompt]

set yarn_add_two_hyphen_completion [string cat \
  "--cached       --dev          --interactive  --optional     --prefer-dev   \r\n" \
  "--caret        --exact        --json         --peer         --tilde        \r\n" \
  $default_bash_prompt]

set yarn_add_caret_hypen_completion [string cat \
  "--cached       --exact        --json         --peer         --tilde        -E             -P             -i\r\n" \
  "--dev          --interactive  --optional     --prefer-dev   -D             -O             -T             ...\r\n" \
  $default_bash_prompt]

set yarn_add_caret_hypen_completion2 [string cat \
  "--cached       --interactive  --optional     --prefer-dev   -E             -P             -i             \r\n" \
  "--exact        --json         --peer         --tilde        -O             -T             ...            \r\n" \
  $default_bash_prompt]

set yarn_add_caret_hypen_completion3 [string cat \
  "--cached       --interactive  --peer         --tilde        -P             -i             \r\n" \
  "--exact        --json         --prefer-dev   -E             -T             ...            \r\n" \
  $default_bash_prompt]

set yarn_ex_completion [string cat "exec     explain  \r\n" $default_bash_prompt ]

set yarn_exec_a_completion [string cat \
  "acpid               addgroup            apk                 arp                 autoexpect          \r\n" \
  "add-shell           adduser             applygnupgdefaults  arping              autopasswd          \r\n" \
  "addgnupghome        adjtimex            arch                ash                 awk                 \r\n" \
  $default_bash_prompt]

set yarn_in_completion [string cat "info     init     install  \r\n" $default_bash_prompt]

set yarn_info_completion [string cat \
  "--all         --dependents  --json        --name-only   --virtuals    -R            ...           \r\n" \
  "--cache       --extra #0    --manifest    --recursive   -A            -X            \r\n" \
  $default_bash_prompt
]

set yarn_info_completion1 [string cat \
  "--all         --dependents  --manifest    --recursive   -A            ...           \r\n" \
  "--cache       --json        --name-only   --virtuals    -R            \r\n" \
  $default_bash_prompt
]

set yarn_test1_workspace_completion [string cat \
  "wrk-a  wrk-b  wrk-c  \r\n" \
  $default_bash_prompt
]

set yarn_test1_workspace_completion1 [string cat \
  "add           config        exec          install       pack          rebuild       setup         why           \r\n" \
  "bin           dedupe        explain       link          patch         remove        test          \r\n" \
  "build         deploy        info          node          patch-commit  run           unplug        \r\n" \
  "cache         dlx           init          npm           plugin        set           up            \r\n" \
  $default_bash_prompt
]

set yarn_test1_workspace_config_completion [string cat \
  "--json     --verbose  --why      -v         get        set        \r\n" \
  $default_bash_prompt
]

set yarn_test1_workspace_run_completion [string cat \
  "--inspect      --inspect-brk  build          deploy         setup          test           \r\n" \
  $default_bash_prompt
]

set yarn_test1_workspace_run_completion2 [string cat \
  "--inspect  build      deploy     setup      test       \r\n" \
  $default_bash_prompt
]

send_and_expect "cd /yarn-2-completion\r"
send_and_expect "stty rows 32\r"
send_and_expect "stty cols 128\r"
send_and_expect "./install.sh\r" "Type in.+\r" "" ".+y/n.+"
send_and_expect "\r" "" "" ".+y/n.+"
send_and_expect "\r" "" "" ".+y/n.+"
send_and_expect "\r" "Install successfully.+"

send_and_expect "exec $env(SHELL)\r"
send_and_expect "cd /yarn-repo/test1\r"

send_and_expect "yarn \t" "" "" $yarn_completion 1
send_and_expect "a\t" "" "" "add " 1
send_and_expect "\t" "" "" $yarn_add_completion 1
send_and_expect "--\t" "" "" $yarn_add_two_hyphen_completion 1
send_and_expect "car\t" "" "" "caret " 1
send_and_expect "\t" "" "" $yarn_add_caret_hypen_completion 1
send_and_expect "-D \t" "" "" $yarn_add_caret_hypen_completion2 1
send_and_expect "--op\t" "" "" "--optional " 1
send_and_expect "\t" "" "" $yarn_add_caret_hypen_completion3 1
send_and_expect "$negative_acknowledge" "" "" $match_final_erase_in_line 1

send_and_expect "yarn e\t" "" "" "^yarn ex" 1
send_and_expect "\t" "" "" $yarn_ex_completion 1
send_and_expect "ec a\t" "" "" $yarn_exec_a_completion 1
send_and_expect "$negative_acknowledge" "" "" $match_final_erase_in_line 1

send_and_expect "yarn in\t" "" "" $yarn_in_completion 1
send_and_expect "f\t" "" "" "fo " 1
send_and_expect "\t" "" "" $yarn_info_completion 1
send_and_expect "--e\t" "" "" "--extra #0 " 1
send_and_expect "\x08\x08\x08" "" "" $match_final_erase_in_line 1
send_and_expect "test \t" "" "" $yarn_info_completion1 1
send_and_expect "$negative_acknowledge" "" "" $match_final_erase_in_line 1

send_and_expect "yarn workspace \t" "" "" "yarn workspace wrk-" 1
send_and_expect "\t" "" "" $yarn_test1_workspace_completion 1
send_and_expect "a \t" "" "" $yarn_test1_workspace_completion1 1
send_and_expect "con\t" "" "" "config " 1
send_and_expect "\t" "" "" $yarn_test1_workspace_config_completion 1
send_and_expect "-v \t" "" "" "-v --" 1
send_and_expect "j\t" "" "" "json " 1
send_and_expect $move_backward_a_word "" "" $match_final_erase_in_line 1
send_and_expect $move_backward_a_word "" "" $match_final_erase_in_line 1
send_and_expect $move_backward_a_word "" "" $match_final_erase_in_line 1

send_and_expect "run \t" "" "" $yarn_test1_workspace_run_completion 1
send_and_expect "--\t" "" "" "inspect" 1
send_and_expect "\t" "" "" "-brk " 1
send_and_expect "\t" "" "" $yarn_test1_workspace_run_completion2 1
