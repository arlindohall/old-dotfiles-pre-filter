# Setup
## Determine when to include work-specific content
get_computer_name() {
    if [[ $(hostname) = *.amazon.com ]] ; then
        echo work
    else
        echo home
    fi
}

# Functions
## Determine git branch
get_main_git_branch() {
  if [[ $(git branch) = *"mainline"* ]] ; then
    echo mainline
  else
    echo master
  fi
}

# Aliases
## Aliases for running common git commands
alias pull-rebase='git checkout $(get_main_git_branch) && git pull && git checkout dev && git rebase $(get_main_git_branch)'
alias push-merge='git push origin dev:$(get_main_git_branch) && git checkout $(get_main_git_branch) && git merge dev && git checkout dev'

## Aliases for common commands
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'

# Environment variables
## Path variables
export PATH=$PATH:$HOME/bin

if [[ $(get_computer_name) = work ]] ; then
    # Aliases
    ## Commonly used programs
    alias rip='/apollo/env/RIPCLI2/bin/ripcli rip'
    alias riph='/apollo/env/RIPCLI2/bin/ripcli help'
    alias aws='/apollo/env/AmazonAwsCli/bin/aws'
    alias sshf='ssh -F /dev/null'
    alias brazil-octane='/apollo/env/OctaneBrazilTools/bin/brazil-octane'
    alias timber='ssh epim2-tests-timberfs-iad-1b-b4b79026.us-east-1.amazon.com'
    alias eh='expand-hostclass --recurse'

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

    ## Aliases for folders
    alias go='cd $HOME/workspace/EpimAwsServiceTests/src/EpimAwsServiceTests'
    alias service='cd $HOME/workspace/EpimAwsServiceTests/src/EpimAwsService'
    alias canary='cd $HOME/workspace/EpimCanary/src/EpimCanaryTest'
    alias ams='cd $HOME/workspace/AccountManagementService/src/AWSAutomationAccountManagementService'
    alias rms='cd $HOME/workspace/ResourceManagementService/src/AWSAutomationResourceManagementService'
    alias ams-ping='curl localhost:8000/deep_ping'
    alias rms-ping='curl localhost:9000/deep_ping'
    alias ers='cd $HOME/ws/EpimReportingService/src/EpimReportingService'
    alias edp='cd $HOME/ws/EpimDataProvider/src/EpimDataProviderService'

    ## Alias to kill running brazil servers (kills all jobs)
    alias brazil-kill="kill -9 \$(brazil-server-name-running)"
    brazil-server-name-running() {
        jobs -l | awk '{print $3}'
    }

    if [ -f $HOME/zshrc-dev-dsk-post ]; then
        source $HOME/zshrc-dev-dsk-post
    fi

    # Environment Variables
    ## Import other zshrc files
    source /apollo/env/WildcardOpsTools/dotfiles/zshrc
    source /apollo/env/envImprovement/var/zshrc

    ## Path variables
    export PATH=$PATH:/apollo/env/WildcardOpsTools/bin
    export PATH=$HOME/.toolbox/bin:$PATH
    export PATH=$PATH:$HOME/jdk-11.0.1/bin/

    for f in envImprovement AmazonAwsCli OdinTools; do
        if [[ -d /apollo/env/$f ]]; then
            export PATH=$PATH:/apollo/env/$f/bin
        fi
    done

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

## Tiger prompt
export PROMPT="%{$fg[cyan]%}%~
%{$fg[green]%}dev-desktop%{$fg[default]%}🐯 $ "
