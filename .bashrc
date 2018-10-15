# Setup
## Determine when to include work-specific content
get_computer_name() {
    if [[ $(hostname) = *.amazon.com ]] ; then
        echo work
    else
        echo home
    fi
}

## Gitconfig simlink
if [[ ! -L $HOME/.gitconfig ]] ; then
    ln -s $HOME/var/rcfiles/gitconfigs/$(get_computer_name) $HOME/.gitconfig
fi

## Bin simlink
if [[ ! -a $HOME/bin ]] ; then
    ln -s $HOME/bar/bin $HOME/bin
elif [[ ! -L $HOME/bin ]] ; then
    mv $HOME/bin $HOME/bin-backup
    ln -s $HOME/var/bin $HOME/bin
fi

# Functions
## Determine git branch
get_main_git_branch() {
  if [[ $(git branch) = *"mainline"* ]] ; then
    echo mainline
  else
    echo master
  fi
}

## Check git repos in a directory
check-git-repos() {
    format_string="%-30s%-20s%-20s\n"
    printf $format_string Directory Branch DiffFromMainline
    for dir in $(ls -1F | grep \/) ; do
        cd $dir
        if [[ $(git status 2>/dev/null) ]] ; then :
        else
            cd ..
            continue
        fi
        printf $format_string $dir \
            $(git rev-parse --symbolic-full-name --abbrev-ref HEAD) \
            $(if [[ $(git diff $(get_main_git_branch) -- .) ]] ; then echo true ; else echo false ; fi)
        cd ..
    done
}


export -f get_main_git_branch

## Make a pandoc preview
alias pandoc-all='for f in $(ls *.md) ; do pandoc $f -o $(basename $f .md).html; done'
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

# Aliases
## Aliases for running common git commands
alias pull-rebase='git checkout $(get_main_git_branch) && git pull && git checkout dev && git rebase $(get_main_git_branch)'
alias push-merge='git push origin dev:$(get_main_git_branch) && git checkout $(get_main_git_branch) && git merge dev && git checkout dev'

## Aliases for common commands
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
alias julia='/Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia'
alias grip='$HOME/.pyenv/versions/3.5.2/bin/grip'
alias flag="grep -Ihori ';[+-]\?\w\+;' ./"
alias flagh="grep -Ihori ';[+-]\?\w\+;' $HOME/var | histogram"
alias journal='vim $HOME/var/journal/$(date +%Y/%m%d.md) && pandoc $HOME/var/journal/$(date +%Y/%m%d.md) -o $HOME/var/journal/$(date +%Y/%m%d.md)'
alias journalcat='cat $HOME/var/journal/$(date +%Y/%m%d.md)'
alias journalgo='cd $HOME/var/journal/$(date +%Y)'
alias note='vim $HOME/var/notes/$(date +%Y/%m%d.md) && pandoc $HOME/var/notes/$(date +%Y/%m%d.md) -o $HOME/var/notes/$(date +%Y/%m%d.md)'
alias notecat='cat $HOME/var/notes/$(date +%Y/%m%d.md)'
alias notego='cd $HOME/var/notes/$(date +%Y)'
alias n='note'
alias meld='open -a Meld'

# Path variables and initialization scripts (can be timely)
## Needs to be above python calls, also used for:
##      - MIDWAY PATH: Path changed for ssh
export PATH=$PATH:/usr/local/bin

## Python init for pyenv
eval "$(pyenv init -)"

## Ruby init for rvm
export PATH="$PATH:$HOME/.rvm/bin"

## Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

## Path variables
export PATH=$PATH:$HOME/bin
export PATH=$PATH:/usr/local/texlive/2017basic/bin/x86_64-darwin/

## Git autocomplete
source $HOME/git-completion.bash

## Avoid /bin/false errors
export SHELL='/bin/bash'

## Tiger prompt
export PS1="\[\e[36m\]\w\[\e[m\]
\[\e[32m\]\u\[\e[m\]🐯 $ "

if [[ $(get_computer_name) = work ]] ; then
    # Aliases
    ## Aliases for connecting/tunneling to dev desktop
    alias cdd-tunnel='ssh -N -L 13390:localhost:3389 millerah.aka.corp.amazon.com -o ProxyCommand=none'
    alias odin-tunnel='ssh -L 2009:localhost:2009 millerah.aka.corp.amazon.com -f -N'
    alias dvd='ssh millerah.aka.corp.amazon.com'
    alias mdvd='mssh -A millerah.aka.corp.amazon.com'
    alias timber='ssh epim2-tests-timberfs-iad-1b-b4b79026.us-east-1.amazon.com'
    alias sshf='ssh -F /dev/null'

    ## Aliases for folders
    alias go='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsServiceTests'
    alias service='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsService'
    alias ams='cd $HOME/ws/AccountManagementService/src/AWSAutomationAccountManagementService'
    alias rms='cd $HOME/ws/ResourceManagementService/src/AWSAutomationResourceManagementService'

    # Functions
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

    ## Mwinit update command
    mwinit-update() {
        curl -O https://s3.amazonaws.com/com.amazon.aws.midway.software/mac/mwinit \
        && chmod u+x mwinit && sudo mv mwinit /usr/local/bin/mwinit
    }

    ## Midway path additions
    export SSH_AUTH_SOCK=$MSSH_AUTH_SOCK    # MIDWAY SSH-AGENT: set as default
    export PATH=$PATH:$HOME/.toolbox/bin    # BuilderTools Toolbox

    ## SSH Aliases for Astra
    alias prod-pdx-up='ssh -fNTM prod-gdp-pdx'
    alias prod-pdx-status='ssh -TO check prod-gdp-pdx'
    alias prod-pdx-down='ssh -TO exit prod-gdp-pdx'
    alias prod-pdx1-a-up='ssh -fNTM prod-pdx1-a'
    alias prod-pdx1-a-status='ssh -TO check prod-pdx1-a'
    alias prod-pdx1-a-down='ssh -TO exit prod-pdx1-a'
    alias prod-pdx1-b-up='ssh -fNTM prod-pdx1-b'
    alias prod-pdx1-b-status='ssh -TO check prod-pdx1-b'
    alias prod-pdx1-b-down='ssh -TO exit prod-pdx1-b'
    alias prod-cmh51-a-up='ssh -fNTM prod-cmh51-a'
    alias prod-cmh51-a-status='ssh -TO check prod-cmh51-a'
    alias prod-cmh51-a-down='ssh -TO exit prod-cmh51-a'
    alias prod-cmh51-b-up='ssh -fNTM prod-cmh51-b'
    alias prod-cmh51-b-status='ssh -TO check prod-cmh51-b'
    alias prod-cmh51-b-down='ssh -TO exit prod-cmh51-b'
fi
