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

diary-synthesize() {
  diary="$(todays-year)"

  echo "" > $diary
  for f in $(ls -1 *.md) ; do
    cat $f >> $diary
    echo "" >> $diary
    echo "" >> $diary
  done

  pandoc $diary -o "$diary.md"
  rm $diary
}

what_are_my_shell_shortcuts() {
  echo "Python:  import code; code.interact(local=dict(globals(), **locals()))"
  echo "Ruby:    require 'pry'; binding.pry"
  echo "RIP:     "rip -r iad -s ers -a custom_properties "|" ruby -pe "'"'$_.gsub!("=>", ":")'"'" "|" jq
}

# Aliases
## Aliases for running common git commands
alias pull-rebase='git checkout $(get_main_git_branch) && git pull && git checkout dev && git rebase $(get_main_git_branch)'
alias push-merge='git push origin dev:$(get_main_git_branch) && git checkout $(get_main_git_branch) && git merge dev && git checkout dev'

## Aliases for common commands
alias julia='/Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia'
alias grip='$HOME/.pyenv/versions/3.5.2/bin/grip'
alias flag="grep -Ihori ';[+-]\?\w\+;' ./"
alias flagh="grep -Ihori ';[+-]\?\w\+;' $HOME/var | histogram"

## Aliases for notes and journals
alias todays-date='echo $(date +%Y/%m%d.md)'
alias todays-year='echo $(date +%Y)'
alias todays-journal='echo $HOME/var/journal/$(todays-date)'
alias todays-note='echo $HOME/var/notes/$(todays-date)'
alias time-right-now='echo $(date +%H:%M)'

alias journal='printf \\n\`$(time-right-now)\`\\n\\n >> $(todays-journal) && vim $(todays-journal) && pandoc $(todays-journal) -o $(todays-journal) && journal-index'
alias journalcat='cat $(todays-journal)'
alias journalgo='cd $HOME/var/journal'
alias journal-index='journalgo && index && cd -'
alias journal-synthesize='cd $HOME/var/journal/$(todays-year) && diary-synthesize && cd -'

alias note='printf \\n\`$(time-right-now)\`\\n\\n >> $(todays-note) && vim $(todays-note) && pandoc $(todays-note) -o $(todays-note) && note-index'
alias notecat='cat $(todays-note)'
alias notego='cd $HOME/var/notes'
alias note-index='notego && index && cd -'
alias note-synthesize='cd $HOME/var/note/$(todays-year) && diary-synthesize && cd -'

## Java 11 over /usr/bin/java
export PATH=/Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/bin/:$PATH

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
    # Start ninja-dev-sync if it's not started
    test -n "$(tmux ls 2>/dev/null | grep ninja)" \
        || (echo Opening ninja-dev-sync tmux session because none exists... \
        && tmux new -d -s ninja ninja-dev-sync)

    # Aliases
    ## Aliases for connecting/tunneling to dev desktop
    alias cdd-tunnel='ssh -N -L 13390:localhost:3389 millerah.aka.corp.amazon.com -o ProxyCommand=none'
    alias odin-tunnel='ssh -L 2009:localhost:2009 millerah.aka.corp.amazon.com -f -N'
    alias dvd='ssh millerah.aka.corp.amazon.com'
    alias mdvd='mssh -A millerah.aka.corp.amazon.com'
    alias timber='ssh epim2-tests-timberfs-iad-1b-4eed9395.us-east-1.amazon.com'
    alias sshf='ssh -F /dev/null'

    ## Aliases for folders
    alias go='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsServiceTests'
    alias service='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsService'
    alias ams='cd $HOME/ws/AccountManagementService/src/AWSAutomationAccountManagementService'
    alias rms='cd $HOME/ws/ResourceManagementService/src/AWSAutomationResourceManagementService'

    ## Shortcuts
    alias bb=brazil-build
    alias brc=brazil-recursive-cmd
    alias bbr='brazil-build release'
    alias bbrec='brc brazil-build release'
    alias bba='brazil-build apollo-pkg'
    alias bre='brazil-runtime-exec'
    alias bws='brazil ws'
    alias bwsuse='bws use --gitMode -p'
    alias bwscreate='bws create -n'
    alias bball='brc --allPackages'
    alias bbra='bbr apollo-pkg'

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
    alias lab-up='ssh -fNTM lab'
    alias lab-status='ssh -TO check lab'
    alias lab-down='ssh -TO exit lab'

    # SAM
    alias samp='brazil-build-tool-exec sam package'
    alias samd='brazil-build-tool-exec sam deploy'
    alias samt='brazil-build-tool-exec sam test'
fi
