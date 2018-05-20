alias cdd-tunnel='ssh -N -L 13390:localhost:3389 millerah.aka.corp.amazon.com'
alias odin-tunnel='ssh -L 2009:localhost:2009 millerah.aka.corp.amazon.com -f -N'
alias devdesktop='ssh millerah.aka.corp.amazon.com'
alias haskell='ghci'
export PS1="millerah$ "
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/apollo/env/SDETools/bin
export PATH=$BRAZIL_CLI_BIN:$PATH

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH=$PATH:/usr/local/bin  # MIDWAY PATH: Path changed for ssh
