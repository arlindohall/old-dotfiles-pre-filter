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
git_get_main_branch() {
  if [[ $(git branch) = *"mainline"* ]] ; then
    echo mainline
  else
    echo master
  fi
}

git_current_branch() {
  git branch | rg '\*' | rg -o '\w+'
}

## Functions for running common git commands
pull-rebase() {
  main=$(git_get_main_branch)
  git fetch && git rebase origin/$main
}

push-merge() {
  current=$(git_current_branch)
  main=$(git_get_main_branch)
  git push origin $current:$main \
    && git checkout $main \
    && git merge origin/$main \
    && git checkout $current
}

## Check git repos in a directory
git_check_repos() {
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
            $(if [[ $(git diff $(git_get_main_branch) -- .) ]] ; then echo true ; else echo false ; fi)
        cd ..
    done
}

# Simple helper to kill a tmux session because typing the command is hard
tmux-kill-session() {
    tmux kill-session -t $1
}

tmux-new-session() {
    name=$1; shift
    cmd=$1

    if test -n "$name"
    then
        if test -n "$cmd"
        then
            tmux new -d -s $name "$cmd"
        else
            tmux new -s $name
        fi
    else
        echo Won\'t start a tmux session without a name...
    fi
}

tmux-list-sessions() {
    echo "$(tmux ls 2>/dev/null)"
}

password-make-file() {
    printf "Enter your Kerberos password... "
    read -s kerb
    printf "Enter your Midway password... "
    read -s mid -p
    echo "$kerb $mid" | openssl enc -e -aes256 -out .kmi
}

password-get() {
    cmd=$1
    passw=$2
    case $cmd in
        kerb)
        echo $(password-get-all $passw) | cut -f 1 -d ' '
        ;;
        mid)
        echo $(password-get-all $passw) | cut -f 2 -d ' '
        ;;
    esac
}

password-get-all() {
    openssl enc -d -aes256 -pass pass:"$1" -in .kmi
}

kmi() {
    printf "Enter your password... "
    read -s pass
    echo $(password-get kerb $pass) | kinit -f
    echo $(password-get mid  $pass) | mwinit
}

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

## Aliases for tmux commands
alias tks='tmux-kill-session'
alias tns='tmux-new-session'
alias tls='tmux-list-sessions'

## Aliases for common commands
alias lisp='sbcl'
alias bfg='java -jar /opt/bfg.jar'
alias julia='/Applications/Julia-1.0.app/Contents/Resources/julia/bin/julia'
alias grip='$HOME/.pyenv/versions/3.7.5/bin/grip'
alias flag="rg -INo ';[+-]?\w+;'"
alias flagh="flag | histogram"
alias flagh-var="cd $HOME/var && flagh && cd -"
alias flagh-note="cd $HOME/var/notes && flagh && cd -"
alias flagh-journal="cd $HOME/var/journal && flagh && cd -"

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
alias note-synthesize='cd $HOME/var/notes/$(todays-year) && diary-synthesize && cd -'
alias yearcat='for f in $HOME/var/notes/$(todays-year)/*.md ; do cat $f ; echo ; echo ; done'

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
    ninja() {
        if (test -n "$(tmux-list-sessions | grep ninja)")
        then
            echo Killing exising ninja-dev-sync session and starting a new one...
            tmux-kill-session ninja
        else
            echo Opening ninja-dev-sync tmux session because none exists...
        fi
        tmux-new-session ninja ninja-dev-sync
    }
    tunnel-webpack() {
        tunnel webpack-tunnel 8080 8080
    }
    tunnel-cdd() {
        tunnel cdd-tunnel 13390 3389 -o ProxyCommand=none
    }
    tunnel-odin() {
        tunnel odin-tunnel 2009 2009
    }

    tunnel() {
        name=$1; shift
        localPort=$1; shift
        destPort=$1; shift
        opts=$@

        cmd="ssh -N -L $localPort:localhost:$destPort millerah.aka.corp.amazon.com $opts"

        if test -n "$(tmux-list-sessions | grep $name)"
        then
            echo Killing existing $name session and restarting it...
            tmux-kill-session $name
        else
            echo Starting a new $name session because none exists...
        fi

        echo $cmd
        tmux-new-session $name "$cmd"
    }

    # Aliases
    alias mdvd='mssh -A millerah.aka.corp.amazon.com'
    alias dvd=mdvd
    alias timber='ssh epim2-tests-timberfs-iad-1b-4eed9395.us-east-1.amazon.com'
    alias sshf='ssh -F /dev/null'

    ## Aliases for folders
    alias go='cd $HOME/ws/RbqWebsite/src/RbqStaticWebsiteAssets'
    alias reticle='cd $HOME/ws/EpimAwsServiceTests/src/EpimAwsServiceTests'
    alias canary='cd $HOME/ws/EpimCanary/src/EpimCanaryTest'
    alias ams='cd $HOME/ws/AccountManagementService/src/AWSAutomationAccountManagementService'
    alias rms='cd $HOME/ws/ResourceManagementService/src/AWSAutomationResourceManagementService'
    alias ers='cd $HOME/ws/EpimReportingService/src/EpimReportingService'
    alias edp='cd $HOME/ws/EpimDataProvider/src/EpimDataProviderService'

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
    alias bjs='jshell --class-path "$(brazil-path run.classpath)"'

    ## Mwinit update command
    mwinit-update() {
        curl -O https://s3.amazonaws.com/com.amazon.aws.midway.software/mac/mwinit \
        && chmod u+x mwinit && sudo mv mwinit /usr/local/bin/mwinit
    }

    ## Midway path additions
    export SSH_AUTH_SOCK=$MSSH_AUTH_SOCK    # MIDWAY SSH-AGENT: set as default
    export PATH=$PATH:$HOME/.toolbox/bin    # BuilderTools Toolbox

    # SAM
    alias sam='brazil-build-tool-exec sam'

    # Set the PEM according to https://w.amazon.com/bin/view/Midway/Operations/AwsCliIsengardMac/
    export REQUESTS_CA_BUNDLE=$HOME/internal_and_external_cacerts.pem
fi
