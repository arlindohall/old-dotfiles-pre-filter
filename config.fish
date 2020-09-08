# Aliases

## Aliases for git commands
alias gg='git goal'
alias gd='git dag'

## Alias for programs
alias grep='rg'
alias lisp='sbcl'
alias jk='tput reset'

## Aliases for tmux commands
alias tns='tmux_new_session'
alias tks='tmux kill-session -t'
alias tls="echo (tmux ls 2>/dev/null)"

## Use local path first
set -p PATH ~/var/bin

source ~/.cargo/env
if test (is_devdesktop) = no
    source ~/.config/fish/mac_config.fish
else
    source ~/.config/fish/dev_config.fish
end

# Suppress greeting
set fish_greeting

# Use vim
fish_vi_key_bindings

# Work configs both Mac and Linux
if test (get_computer_name) = work
    # Work path variables
    set -p PATH ~/.toolbox/bin

    # Work aliases

    ## Unsure if I still use these
    # alias rip '/apollo/env/RIPCLI2/bin/ripcli rip'
    # alias eh 'expand-hostclass --recurse'

    ## Brazil shortcuts
    alias bb        brazil-build
    alias brc       brazil-recursive-cmd
    alias bbr       'brazil-build release'
    alias bbrec     'brc brazil-build release'
    alias bball     'brc --allPackages brazil-build'
    alias bjs       'jshell --class-path (brazil-path run.classpath)'
    alias rst       'rde stack'
    alias renv      'rde env'

    ## Other amazon shortcuts
    alias sam       'brazil-build-tool-exec sam'

    ## Mwinit update command
    function mwinit-update
        curl -O https://s3.amazonaws.com/com.amazon.aws.midway.software/mac/mwinit \
            && chmod u+x mwinit \
            && sudo mv mwinit /usr/local/bin/mwinit
    end

    ## Validate cloudformation templates
    function validate-cloudformation
        aws s3 cp build/sam/template.yml s3://millerah-dev-scratch/cfn-templates/demoimage \
            && aws cloudformation validate-template \
                --template-url https://millerah-dev-scratch.s3.us-east-2.amazonaws.com/cfn-templates/demoimage
    end
end


if test (get_computer_name) = work
    set -x AWS_PROFILE millerah
else
    set -x AWS_PROFILE miller
end
