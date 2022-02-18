# Aliases

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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
