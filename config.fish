# Aliases

## Aliases for git commands
alias gg 'git goal'
alias gd 'git dag'

## Alias for programs
alias grep 'rg'
alias lisp 'sbcl'
alias jk 'tput reset'
alias rvm '~/.rvm/bin/rvm'

## Aliases for tmux commands
alias tns 'tmux_new_session'
alias tks 'tmux kill-session -t'
alias tls "echo (tmux ls 2>/dev/null)"

## Check for bad words
##
## This would otherwise be a rust binary, but because I'm
## pleased with using curl here and I don't want to add
## libcurl to the dependencies of the rust package, I think
## this will suffice. Also I don't want to call back to the
## shell for libcurl when there's a rust dependency for it.
function manners
    if test ! -f /tmp/swearWords.txt
        curl -o /tmp/swearWords.txt http://www.bannedwordlist.com/lists/swearWords.txt
    end
    tr -d ' ' < /tmp/swearWords.txt | tr -d '\r' | tr '\n' '|' | sed 's/.$//g' | xargs rg -w
end

## Hexdump is so hard to use
alias hd-rows "hexdump -e '16/1 \"%02x\" \"\n\"'"
alias hd "hexdump -e '\"%02x\"'"

## Use local path first
set -p PATH ~/var/bin

## Added for MacPorts/GNU Radio
set -a PATH /opt/local/bin
set -a PATH /opt/local/sbin

source ~/.cargo/env
if test (is_devdesktop) = no
    source ~/.config/fish/mac_config.fish
else
    source ~/.config/fish/dev_config.fish
end

# Suppress greeting
set fish_greeting

# Use vim, but remove prompt
fish_vi_key_bindings
alias fish_default_mode_prompt 'echo'
# alias fish_prompt 'echo "; "'

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
    alias bbsr      'brazil-build standard-release'
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
