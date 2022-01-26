## Path variables
fish_add_path -p ~/pybin/bin
fish_add_path /usr/local/bin
fish_add_path -p /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk/Contents/Home/bin/


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

