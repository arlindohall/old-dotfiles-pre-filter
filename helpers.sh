
#### Top-level command ###
function install {
    if hostname | grep 'work' && is_mac ; then
        install_work_mac
    elif hostname | grep 'home' && is_mac ; then
        install_home_mac
    elif hostname | grep 'droplet' && is_linux ; then
        install_home_linux
    else
        install_work_linux
    fi
}

#### Utility functions ####
function rc_install {
    source=$1
    dest=$HOME/$2

    cp $source $dest
}

function is_linux {
    uname | grep -i 'linux'
}

function is_mac {
    uname | grep -i 'darwin'
}

function set_up_directory_structure {
    mkdir -p $HOME/.rm-trash-can
    mkdir -p $HOME/var
    mkdir -p $HOME/workspace
}