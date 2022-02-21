#!/bin/bash

#### Top-level command ###
function install {
    if $(is_mac) ; then
        install_mac
    elif $(is_linux) ; then
        install_linux
    fi
}

#### Utility functions ####
function is_mac {
    ruby -e 'puts `uname`.downcase.include? "darwin"'
}

function is_linux {
    ruby -e 'puts !`uname`.downcase.include? "darwin"'
}

function is_work {
    ruby -e 'puts `hostname`.downcase.include? "work"'
}

function is_home {
    ruby -e 'puts `hostname`.downcase.include? "home"'
}

#### Delegate commands ####
function install_mac {
    if is_work ; then
        install_work_mac
    elif is_home ; then
        install_home_mac
    fi
}

function install_linux {
    if is_work ; then
        install_work_linux
    elif is_home ; then
        install_home_linux
    fi
}

#### Dotfile placement and env config ####

#### Specific installations ####
function install_homebrew {
    if which brew ; then
        return
    fi

    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_rust {
    if which cargo ; then
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

    $(gpg_command) --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://get.rvm.io | bash -s stable
}

function install_pybin {
    if ls $HOME/pybin ; then
        return
    fi

    cd $HOME
    python3 -m venv pybin
}

function homebrew_tools_installed {
    brew list | grep rg &&
        brew list | grep fish &&
        brew list | grep node &&
        brew list | grep watch
}

function install_homebrew_tools {
    if homebrew_tools_installed ; then
        return
    fi

    brew install \
        rg \
        fish \
        node \
        watch
}

function install_git {
    if which git ; then
        return
    fi

    if $(is_linux) ; then
        apt install git
    elif
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
        cd /opt/

        unzip amazon-corretto-11-x64-linux-jdk.tar.gz

        cd $HOME
    elif $(is_mac) ; then
        echo "Install java from the amazon downloads page: [link should open automatically]"
        echo "For help see: https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/macos-install.html"
        open "https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/macos-install.html"
    fi
}
