# Aliases
alias cdd-tunnel='ssh -N -L 13390:localhost:3389 millerah.aka.corp.amazon.com -o ProxyCommand=none'
alias odin-tunnel='ssh -L 2009:localhost:2009 millerah.aka.corp.amazon.com -f -N'
alias pull-rebase='git checkout mainline && git pull && git checkout dev && git rebase mainline'
alias push-merge='git push origin dev:mainline && git checkout mainline && git merge dev && git checkout dev'
alias dvd='ssh millerah.aka.corp.amazon.com'
alias mdvd='mssh -A millerah.aka.corp.amazon.com'
alias aws='/usr/local/bin/aws'
alias sshf='ssh -F /dev/null'
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'
alias dev-sync='ninja-dev-sync 1>/dev/null 2>/dev/null &'
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'

alias bbr='brazil-build release'

# Aliases for folders
alias go='cd ~/workspace/EpimAwsServiceTests/src/EpimAwsServiceTests'
alias ams='cd ~/workspace/AccountManagementService/src/AWSAutomationAccountManagementService'
alias rms='cd ~/workspace/ResourceManagementService/src/AWSAutomationResourceManagementService'

# Mwinit update
mwinit-update() {
    curl -O https://s3.amazonaws.com/com.amazon.aws.midway.software/mac/mwinit \
    && chmod u+x mwinit && sudo mv mwinit /usr/local/bin/mwinit
}

# Midway path additions
export PATH=$PATH:/usr/local/bin        # MIDWAY PATH: Path changed for ssh
export SSH_AUTH_SOCK=$MSSH_AUTH_SOCK    # MIDWAY SSH-AGENT: set as default

# Path variables
export PATH=$PATH:/Users/millerah/bin

# Python init for pyenv
eval "$(pyenv init -)"

# Ruby init for rvm
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# BuilderTools Toolbox
export PATH=$PATH:/Users/millerah/.toolbox/bin

# LaTeX
export PATH=$PATH:/usr/local/texlive/2017basic/bin/x86_64-darwin/

# Git autocomplete
source ~/git-completion.bash

# Avoid /bin/false errors
export SHELL='/bin/bash'

export PS1="\[\e[36m\]\w\[\e[m\]
\[\e[32m\]\u\[\e[m\]🐯 $ "

# Timber shortcut
alias timber='ssh epim2-tests-timberfs-iad-1a-056e4c0b.us-east-1.amazon.com'

# GRIP
# PyEnv
# eval "$(pyenv init -)"
alias grip='/Users/millerah/.pyenv/versions/3.5.2/bin/grip'

# getmethodnames() { cat $1 | grep -o '[a-zA-Z]*(' | while read -r line ; do wordt=$(echo $line | grep -o '[a-zA-z]*') ; echo $wordt ; done; }
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# Include bash_profile
source ~/.bash_profile

# Make a pandoc preview
alias preview='open -a Preview'
pdfview() {
  if [ ! -z "$1" ]
  then
    echo "Reading file $1..."
    echo "Compiling PDF document using LaTeX and Pandoc..."
    pandoc $1 -o /tmp/show_pandoc.pdf && preview /tmp/show_pandoc.pdf
    # echo "Displaying PDF document, press ENTER to continue..."
    # read
    # Do not remove temp file
    # Allow next run to clean up by overwriting
  else
    echo "USAGE:"
    echo "    pdfview <file>"
  fi
}
