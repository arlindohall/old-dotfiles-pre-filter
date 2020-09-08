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

## Use local path first
export PATH=~/var/bin:$PATH

## Aliases for journal and notes

if [[ $(is_devdesktop) = no ]] ; then
    ## Gitconfig simlink
    if [[ ! -L $HOME/.gitconfig ]] ; then
        ln -s $HOME/var/rcfiles/gitconfigs/$(get_computer_name) $HOME/.gitconfig
    fi

    ## Aliases for notes and journals
    alias todays-date='echo $(date +%Y/%m%d.md)'
    alias todays-year='echo $(date +%Y)'
    alias todays-journal='echo $HOME/var/journal/$(todays-date)'
    alias todays-note='echo $HOME/var/notes/$(todays-date)'
    alias time-right-now='echo $(date +%H:%M)'

    alias journalcat='cat $(todays-journal)'
    alias journalgo='cd $HOME/var/journal'
    alias journal-index='journalgo && index && cd -'

    alias notecat='cat $(todays-note)'
    alias notego='cd $HOME/var/notes'
    alias note-index='notego && index && cd -'
    alias note-preview='grip `todays-note`'
    alias note-preview-index='grip $HOME/var/notes/INDEX.md'
    alias yearcat='for f in $HOME/var/notes/$(todays-year)/*.md ; do cat $f ; echo ; echo ; done'
fi

if [[ $(is_devdesktop) = no ]] ; then
    # Date, time, journal and notes functions
    # in a separate block because of some zsh scoping rules I
    # don't have time to look up
    note() {
        if [[ ! -f $(todays-note) ]] ; then
            date +'# %B %d %Y' > $(todays-note)
        fi
        printf \\n\`$(time-right-now)\`\\n\\n >> $(todays-note)
        vim $(todays-note)
        pandoc $(todays-note) -o $(todays-note)
        note-index
    }

    journal() {
        if [[ ! -f $(todays-journal) ]] ; then
            date +'# %B %d %Y' > $(todays-journal)
        fi
        printf \\n\`$(time-right-now)\`\\n\\n >> $(todays-journal)
        vim $(todays-journal)
        pandoc $(todays-journal) -o $(todays-journal)
        journal-index
    }
fi

# Path variables and initialization scripts (can be timely)
## Needs to be above python calls, also used for:
##      - MIDWAY PATH: Path changed for ssh
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/jdk/bin/

## Zsh autocomplete
source $HOME/.git-completion.bash 2>/dev/null   # I know it's deprecated
# Bash one works good enough
# source $HOME/.git-completion.zsh

if [[ $(get_computer_name) = work ]] ; then
    # Work-specific Aliases
    ## Commonly used programs
    alias rip='/apollo/env/RIPCLI2/bin/ripcli rip'
    alias riph='/apollo/env/RIPCLI2/bin/ripcli help'
    alias eh='expand-hostclass --recurse'

    ## Brazil Shortcuts
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
    alias rst='rde stack'
    alias renv='rde env'

    ## Other programs
    alias sam='brazil-build-tool-exec sam'

    ## Mwinit update command
    mwinit-update() {
        curl -O https://s3.amazonaws.com/com.amazon.aws.midway.software/mac/mwinit \
        && chmod u+x mwinit && sudo mv mwinit /usr/local/bin/mwinit
    }

    ## Validate cloudformation templates
    validate-cloudformation () {
        aws s3 cp build/sam/template.yml s3://millerah-dev-scratch/cfn-templates/demoimage &&
        aws cloudformation validate-template \
                --template-url https://millerah-dev-scratch.s3.us-east-2.amazonaws.com/cfn-templates/demoimage
    }

    if [ -f $HOME/zshrc-dev-dsk-post ]; then
        source $HOME/zshrc-dev-dsk-post
    fi

    # Work-specific Path variables
    export PATH=$HOME/.toolbox/bin:$PATH

    if [[ $(is_devdesktop) = yes ]] ; then
        for f in envImprovement AmazonAwsCli OdinTools; do
            if [[ -d /apollo/env/$f ]]; then
                export PATH=$PATH:/apollo/env/$f/bin
            fi
        done

        # Environment Variables
        ## Import other zshrc files
        source /apollo/env/envImprovement/var/zshrc

        export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
    else
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

            cmd="ssh -N -L ${localPort}:localhost:${destPort} desktop $opts"

            if test -n "$(tmux-list-sessions | grep $name)"
            then
                echo Killing existing $name session and restarting it...
                tmux-kill-session $name
            else
                echo Starting a new $name session because none exists...
            fi

            echo "$cmd"
            tmux-new-session $name "$cmd"
        }

        # Set the PEM according to https://w.amazon.com/bin/view/Midway/Operations/AwsCliIsengardMac/
        export REQUESTS_CA_BUNDLE=$HOME/internal_and_external_cacerts.pem
    fi

    ## SSH helper
    set-title() {
        echo -e "\e]0;$*\007"
    }

    ssh() {
        set-title $*;
        /usr/bin/ssh -2 $*;
        set-title $HOST;
    }

    ## Miscelaneous env varibales
    export AUTO_TITLE_SCREENS="NO"
    export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
fi

# Fun stuff

if [[ $(is_devdesktop) = no ]] ; then
    autoload -U colors && colors
fi

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

## AWS Profiles
if [[ $(get_computer_name) = work ]] ; then
    export AWS_PROFILE=millerah
else
    export AWS_PROFILE=miller
fi
