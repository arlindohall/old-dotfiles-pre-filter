# Aliases

## Aliases for connecting/tunneling to dev desktop
alias cdd-tunnel='ssh -N -L 13390:localhost:3389 millerah.aka.corp.amazon.com -o ProxyCommand=none'
alias odin-tunnel='ssh -L 2009:localhost:2009 millerah.aka.corp.amazon.com -f -N'
alias dvd='ssh millerah.aka.corp.amazon.com'
alias mdvd='mssh -A millerah.aka.corp.amazon.com'
alias timber='ssh epim2-tests-timberfs-iad-1b-b4b79026.us-east-1.amazon.com'
alias sshf='ssh -F /dev/null'

## Aliases for running common git commands
alias pull-rebase='git checkout $(get_main_git_branch) && git pull && git checkout dev && git rebase $(get_main_git_branch)'
alias push-merge='git push origin dev:$(get_main_git_branch) && git checkout $(get_main_git_branch) && git merge dev && git checkout dev'

get_main_git_branch() {
  if [[ $(git branch) = *"mainline"* ]] ; then
    echo mainline
  elif [[ $(pwd) = *"rcfiles" ]] ; then
    echo work
  else
    echo master
  fi
}

export -f get_main_git_branch

## Aliases for common commands
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
alias notes="cat >> $HOME/db/notes/$(date +%Y/%m%d.md)"
alias meld='open -a Meld'
alias grip='/Users/millerah/.pyenv/versions/3.5.2/bin/grip'

## Brazil Recursive Command
bbr() {
    brc "echo \"@@@ Building \$(pwd) @@@\" && brazil-build release"
}
brc() {
    echo "########## Running brazil command recursively ##########"
    brazil-recursive-cmd "$@"
}

export -f bbr
export -f brc

## Aliases for folders
alias go='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsServiceTests'
alias service='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsService'
alias ams='cd $HOME/ws/AccountManagementService/src/AWSAutomationAccountManagementService'
alias rms='cd $HOME/ws/ResourceManagementService/src/AWSAutomationResourceManagementService'

# Mwinit update
mwinit-update() {
    curl -O https://s3.amazonaws.com/com.amazon.aws.midway.software/mac/mwinit \
    && chmod u+x mwinit && sudo mv mwinit /usr/local/bin/mwinit
}

# Path variables and initialization scripts (can be timely)

## Midway path additions
export PATH=$PATH:/usr/local/bin        # MIDWAY PATH: Path changed for ssh
export SSH_AUTH_SOCK=$MSSH_AUTH_SOCK    # MIDWAY SSH-AGENT: set as default

## Python init for pyenv
eval "$(pyenv init -)"

## Ruby init for rvm
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"    # Load RVM into a shell session *as a function*

## Miscelaneous path and env variables
export PATH=$PATH:/Users/millerah/.toolbox/bin                          # BuilderTools Toolbox
export PATH=$PATH:$HOME/bin                                             # Personal scripts
export PATH=$PATH:/usr/local/texlive/2017basic/bin/x86_64-darwin/       # LaTeX

source $HOME/git-completion.bash                                        # Git autocomplete
export SHELL='/bin/bash'                                                # Avoid /bin/false errors

export PS1="\[\e[36m\]\w\[\e[m\]
\[\e[32m\]\u\[\e[m\]🐯 $ "                                               # Tiger prompt

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
