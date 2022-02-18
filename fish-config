# Aliases

## Upgrade the aws CLI (base version)
function upgrade_aws
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
    sudo installer -pkg AWSCLIV2.pkg -target /
end

## Aliases for git commands
alias gg 'git goal'
alias gd 'git dag'

## Alias for programs
alias grep 'rg'
alias lisp 'sbcl'
alias jk 'tput reset'

## Aliases for tmux commands
alias tns 'tmux_new_session'
alias tks 'tmux kill-session -t'
alias tls "echo (tmux ls 2>/dev/null)"

## Run pi-hole locally
alias pihole 'docker run --rm -d -v pihole-etc:/etc/ -p 6080:80 -p 53:53/tcp -p 53:53/udp --name pihole pihole/pihole:latest'

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

function dl
    mv $argv $HOME/.rm-trash-can/
end

## Hexdump is so hard to use
alias hd-rows "hexdump -e '16/1 \"%02x\" \"\n\"'"
alias hd "hd-rows | tr -d '\n' | tr -d ' '"

## Use local path first
fish_add_path -p ~/var/bin

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
# alias fish_default_mode_prompt 'echo'
# alias fish_prompt 'echo "; "'

set -x AWS_PAGER ''
set -x AWS_PROFILE miller

rvm default
