# Aliases

## Commonly used programs
alias rip='ripcli rip'
alias riph='ripcli help'
alias aws='/apollo/env/AmazonAwsCli/bin/aws'
alias sshf='ssh -F /dev/null'
alias brazil-octane='/apollo/env/OctaneBrazilTools/bin/brazil-octane'
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'
alias eh='expand-hostclass --recurse'

## Shortcuts
alias bb=brazil-build
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
alias ams='cd $HOME/workspace/AccountManagementService/src/AWSAutomationAccountManagementService'
alias rms='cd $HOME/workspace/ResourceManagementService/src/AWSAutomationResourceManagementService'

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
export PATH=$PATH:$HOME/bin

for f in envImprovement AmazonAwsCli OdinTools; do
    if [[ -d /apollo/env/$f ]]; then
        export PATH=$PATH:/apollo/env/$f/bin
    fi
done

## Tiger prompt
export PROMPT="%{$fg[cyan]%}%~
%{$fg[green]%}dev-desktop%{$fg[default]%}🐯 $ "

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

## Brazil Recursive Command
unalias bbr
bbr() {
    brc "echo \"@@@ Building \$(pwd) @@@\" && brazil-build release"
}
brc() {
    echo "########## Running brazil command recursively ##########"
    brazil-recursive-cmd "$@"
}

export -f bbr
export -f brc
