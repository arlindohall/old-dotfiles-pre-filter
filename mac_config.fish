## Path variables
set -p PATH ~/pybin/bin
set -a PATH /usr/local/bin
# set -a PATH /opt/java/bin
set -p PATH /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/bin/


## Git config simlink
if test ! -L ~/.gitconfig
    ln -s ~/var/rcfiles/gitconfigs/(get_computer_name) ~/.gitconfig
end


## Aliases for notes and journals
alias 'todays-date'         'echo (date +%Y/%m%d.md)'
alias 'todays-year'         'echo (date +%Y)'
alias 'todays-journal'      'echo ~/var/journal/src/(todays-date)'
alias 'todays-note'         'echo ~/var/notes/src/(todays-date)'
alias 'time-right-now'      'echo (date +%H:%M)'

alias journalcat            'cat (todays-journal)'
alias journalgo             'cd ~/var/journal/src'
alias 'journal-index'       'journalgo && index && cd -'

alias notecat               'cat (todays-note)'
alias notego                'cd ~/var/notes/src'
alias 'note-index'          'notego && index && cd -'

alias 'note-preview'        'cd ~/var/notes ; fish build.fish ; cd -'
alias yearcat               'cat ~/var/notes/src/(todays-year)/*.md'


function note
    if test ! -f (todays-note)
        date +'# %B %d %Y' > (todays-note)
    end
    echo >> (todays-note)
    echo (time-right-now) >> (todays-note)
    echo >> (todays-note)
    echo >> (todays-note)
    vim (todays-note)
    pandoc (todays-note) -o (todays-note)
    note-index
end

function journal
    if test ! -f (todays-journal)
        date +'# %B %d %Y' > (todays-journal)
    end
    echo >> (todays-journal)
    echo (time-right-now) >> (todays-journal)
    echo >> (todays-journal)
    echo >> (todays-journal)
    vim (todays-journal)
    pandoc (todays-journal) -o (todays-journal)
    journal-index
end


# Work specific configurations
if test (get_computer_name) = work
    function ninja --wraps=ninja-dev-sync
        tls | grep ninja
        if test $status -eq 0 # match found, 1 is no mathc
            echo Killing existing ninja-dev-sync session and starting a new one...
            tks ninja
        else
            echo Opening ninja-dev-sync tmux session because none exists...
        end
        tns ninja ninja-dev-sync
    end

    function tunnel
        set name $argv[1]
        set localPort $argv[2]
        set destPort $argv[3]
        set opts $argv[4..-1]

        set cmd 'ssh -N -L $localPort:localhost:$destPort desktop $opts'

        tls | grep ninja
        if test $status -eq 0
            echo Killing existing $name session and restarting it...
            tks $name
        else
            echo Starting a new $name session because none exists...
        end

        echo $cmd
        tns $name "$cmd"
    end

    alias 'tunnel-webpack'  'tunnel webpack-tunnel 8080 8080'
    alias 'tunnel-cdd'      'tunnel cdd-tunnel 13390 3389 -o ProxyCommand=none'
    alias 'tunnel-odin'     'tunnel odin-tunnel 2009 2009'

    ## SSH helpers
    function ssh --wraps=/usr/bin/ssh
        function fish_title
            echo $argv
        end
        /usr/bin/ssh -2 $argv
        function fish_title
            echo $HOST
        end
    end
end
