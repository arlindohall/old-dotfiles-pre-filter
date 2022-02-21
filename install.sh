#!/bin/bash

set -euxo pipefail

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

function is_linux {
    uname | grep -i 'linux'
}

function is_mac {
    uname | grep -i 'darwin'
}

#### Utility functions ####
function rc_install {
    source=$1
    dest=$HOME/$2

    cp $source $dest
}

#### Dotfile placement and env config ####
function install_home_mac {
    install_homebrew
    install_rust
    install_rvm
    install_pybin
    install_git
    install_openjdk

    install_homebrew_tools

    rc_install bash-bash_profile        .bash_profile
    rc_install fish-config              .config/fish/config.fish
    rc_install fish-mac_config          .config/fish/mac_config.fish
    rc_install gitconfig-home           .gitconfig
    rc_install sh-inputrc               .inputrc
    rc_install sh-profile               .profile
    rc_install tmux-conf                .tmux.conf
    rc_install tmux-conf_local          .tmux.conf.local
    rc_install vim-vimrc                .vimrc
}

function install_home_linux {
    install_homebrew
    install_rust
    install_rvm
    install_pybin
    install_git
    install_openjdk

    install_homebrew_tools

    rc_install bash-bash_profile        .bash_profile
    rc_install fish-config              .config/fish/config.fish
    rc_install gitconfig-home           .gitconfig
    rc_install sh-inputrc               .inputrc
    rc_install sh-profile               .profile
    rc_install tmux-conf                .tmux.conf
    rc_install tmux-conf_local          .tmux.conf.local
    rc_install vim-vimrc                .vimrc
}

function install_work_mac {
    install_homebrew
    install_rust
    install_rvm
    install_pybin
    install_git

    install_homebrew_tools

    rc_install bash-bash_profile        .bash_profile
    rc_install fish-config              .config/fish/config.fish
    rc_install fish-mac_config          .config/fish/mac_config.fish
    rc_install gitconfig-work           .gitconfig
    rc_install sh-inputrc               .inputrc
    rc_install sh-profile               .profile
    rc_install tmux-conf                .tmux.conf
    rc_install tmux-conf_local          .tmux.conf.local
    rc_install vim-vimrc                .vimrc
}

function install_work_linux {
    ## Dotfiles only for now
    rc_install gitconfig-work           .gitconfig
    rc_install sh-inputrc               .inputrc
    rc_install sh-profile               .profile
    rc_install tmux-conf                .tmux.conf
    rc_install tmux-conf_local          .tmux.conf.local
    rc_install vim-vimrc                .vimrc
}

#### Specific installations ####
function install_homebrew {
    if which brew ; then
        return
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_rust {
    if ls $HOME/.cargo/bin/cargo ; then
        return
    fi

    curl https://sh.rustup.rs -sSf | sh
}

function install_rvm {
    if which rvm ; then
        return
    fi

    if which gpg2 ; then
        gpg_command=gpg2
    else
        gpg_command=gpg
    fi

    $gpg_command --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable

    # Fish configuration
    curl -L --create-dirs -o $HOME/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish
}

function install_pybin {
    if ls $HOME/pybin ; then
        return
    fi

    python3 -m venv $HOME/pybin
}

function homebrew_tools_installed {
    which rg && which watch && which node && which fish && which tmux
}

function install_homebrew_tools {
    if homebrew_tools_installed ; then
        return
    fi

    brew install \
        rg \
        fish \
        node \
        tmux \
        watch
}

function install_git {
    if which git ; then
        return
    fi

    if $(is_linux) ; then
        apt install git
    else
        xcode-select --install
    fi
}

function install_openjdk {
    if ls /opt/amazon-corretto-11/ || ls /Library/Java/JavaVirtualMachines/amazon-corretto-11.jdk ; then
        return
    fi

    if $(is_linux) ; then
        curl -LO https://corretto.aws/downloads/latest/amazon-corretto-11-x64-linux-jdk.tar.gz
        sudo mv amazon-corretto-11-x64-linux-jdk.tar.gz /opt/

        read -p "In a new shell, unzip the corretto installation, press any key to continue..."
    elif $(is_mac) ; then
        echo "Install java from the amazon downloads page: [link should open automatically]"
        echo "For help see: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/macos-install.html"
        open "https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/macos-install.html"
        read -p "Press any key to continue"
    fi
}

install