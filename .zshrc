source /apollo/env/envImprovement/var/zshrc

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short

export PATH=$PATH:/home/millerah/bin

for f in SDETools envImprovement AmazonAwsCli OdinTools; do
    if [[ -d /apollo/env/$f ]]; then
        export PATH=$PATH:/apollo/env/$f/bin
    fi
done

export AUTO_TITLE_SCREENS="NO"

export PROMPT="%{$fg[cyan]%}%~
%{$fg[green]%}dev-desktop%{$fg[default]%}🐯 $ "

export RPROMPT=

set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

alias e=emacs
alias bb=brazil-build

alias bba='brazil-build apollo-pkg'
alias bre='brazil-runtime-exec'
alias brc='brazil-recursive-cmd'
alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'
alias brc=brazil-recursive-cmd
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'

brazil-server-name-running() {
    jobs -l | awk '{print $3}'
}

alias brazil-kill="kill -9 \$(brazil-server-name-running)"

alias rip='ripcli rip'
alias riph='ripcli help'

if [ -f ~/.zshrc-dev-dsk-post ]; then
    source ~/.zshrc-dev-dsk-post
fi

# Personal Aliases
alias go='cd /home/millerah/workspace/EpimAwsServiceTests/src/EpimAwsServiceTests'
alias aws='/apollo/env/AmazonAwsCli/bin/aws'
alias sshf='ssh -F /dev/null'
alias brazil-octane='/apollo/env/OctaneBrazilTools/bin/brazil-octane'
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'
source /apollo/env/WildcardOpsTools/dotfiles/zshrc
