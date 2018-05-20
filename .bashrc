# Aliases
alias cdd-tunnel='ssh -N -L 13390:localhost:3389 millerah.aka.corp.amazon.com -o ProxyCommand=none'
alias odin-tunnel='ssh -L 2009:localhost:2009 millerah.aka.corp.amazon.com -f -N'
alias pull-rebase='git checkout mainline && git pull && git checkout dev && git rebase mainline'
alias push-merge='git push origin dev:mainline && git checkout mainline && git merge dev && git checkout dev'
alias dvd='ssh millerah.aka.corp.amazon.com'
alias go='cd /Users/millerah/workspace/EpimAwsServiceTests/src/EpimAwsServiceTests'
alias aws='/usr/local/bin/aws'
alias sshf='ssh -F /dev/null'
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'

# Path variables
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:/apollo/env/SDETools/bin
export PATH=$PATH:/Users/millerah/Library/Python/2.7/bin/
export PATH=$BRAZIL_CLI_BIN:$PATH
export PATH=$PATH:/Users/millerah/bin
export SHELL='/bin/bash'

export PS1="\[\e[36m\]\w\[\e[m\]
\[\e[32m\]\u\[\e[m\]🐯 $ "

getmethodnames() { cat $1 | grep -o '[a-zA-Z]*(' | while read -r line ; do wordt=$(echo $line | grep -o '[a-zA-z]*') ; echo $wordt ; done; }
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

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
