[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/Users/millerah/Library/Python/2.7/bin/
export PATH=$PATH:/Users/millerah/bin
export SHELL='/bin/bash'

export PS1="\[\e[36m\]\w\[\e[m\]
\[\e[32m\]\u\[\e[m\]🐯 $ "

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

export PATH=$PATH:/usr/local/bin  # MIDWAY PATH: Path changed for ssh
export SSH_AUTH_SOCK=$MSSH_AUTH_SOCK    # MIDWAY SSH-AGENT: set as default
export PATH=$PATH:/usr/local/bin  # MIDWAY PATH: Path changed for ssh

# Bash completion for RDE
# if [ -f $(brew --prefix)/etc/bash_completion ]; then
# . $(brew --prefix)/etc/bash_completion
# fi
