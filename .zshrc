# Aliases

## Aliases for git commands
alias gg='git goal'

## Alias for programs
alias grep='rg'
alias lisp='sbcl'
alias jk='tput reset'

## Aliases for tmux commands
alias tns='tmux_new_session'
alias tks='tmux kill-session -t'
alias tls='echo $(tmux ls 2>/dev/null)'

# Path variables and initialization scripts (can be timely)
## Needs to be above python calls, also used for:
##      - MIDWAY PATH: Path changed for ssh
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/jdk/bin/

## Tiger prompt
export PROMPT="%{$fg[cyan]%}%~
%{$fg[green]%}%n%{$reset_color%}@%{$fg[yellow]%}%m%{$reset_color%}🐯 "

## History
touch $HOME/.histfile
export HISTFILE=$HOME/.histfile
export SAVEHIST=10000

## Vim mode
bindkey -v

## Rust is lit
source $HOME/.cargo/env
bindkey '^R' history-incremental-search-backward

export AWS_PROFILE=miller

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
