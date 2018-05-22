# Aliases

## Aliases for connecting/tunneling to dev desktop
alias meld='open -a Meld'

## Aliases for running common git commands
alias pull-rebase='git checkout mainline && git pull && git checkout dev && git rebase mainline'
alias push-merge='git push origin dev:mainline && git checkout mainline && git merge dev && git checkout dev'

## Aliases for common commands
alias tree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/" | less'
alias jsc='/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc'
alias grip='/Users/millerah/.pyenv/versions/3.5.2/bin/grip'

# Path variables and initialization scripts (can be timely)

## Python init for pyenv
eval "$(pyenv init -)"

## Ruby init for rvm
export PATH="$PATH:$HOME/.rvm/bin"
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"    # Load RVM into a shell session *as a function*

## Miscelaneous path and env variables
export PATH=$PATH:$HOME/bin                                             # Personal scripts
export PATH=$PATH:/usr/local/texlive/2017basic/bin/x86_64-darwin/       # LaTeX

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
