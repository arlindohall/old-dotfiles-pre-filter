#!/bin/bash

function install {
    if $(is_mac) ; then
        install_mac
    elif $(is_linux) ; then
        install_linux
    fi
}

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
