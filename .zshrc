# Aliases

## Commonly used programs
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'

# Environment Variables

## Path variables
export PATH=$PATH:$HOME/bin

## Tiger prompt
export PROMPT="%{$fg[cyan]%}%~
%{$fg[green]%}dev-desktop%{$fg[default]%}🐯 $ "
