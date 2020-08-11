#!/bin/sh

echo "===> Take Off  - curl, vim, neovim, git, rust, rustup components"

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if [ -f /etc/redhat-release ]; then
        echo "Redhat Linux detected, but current not support sorry."
        exit 1
    elif [ -f /etc/SuSE-release ]; then
        echo "Suse Linux detected, but current not support sorry."
        exit 1
    elif [ -f /etc/arch-release ]; then
        echo "Arch Linux detected."
        sudo pacman -Syu --needed --noconfirm git vim curl
        sudo pacman -Syu --needed --noconfirm neovim
    elif [ -f /etc/mandrake-release ]; then
        echo "Mandrake Linux detected, but current not support sorry."
        exit 1
    elif [ -f /etc/debian_version ]; then
        echo "Ubuntu/Debian Linux detected."
        sudo apt-get -y update
        sudo apt-get install -y git vim curl
        sudo apt-get install -y neovim
    else
        echo "Unknown Linux distribution."
        exit 1
    fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Mac OS (Darwin) detected."
    if ! which brew >/dev/null 2>&1; then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    brew upgrade
    brew install git curl vim
    brew install neovim
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "FreeBSD detected, but current not support sorry."
    exit 1
else
    echo "Unknown operating system."
    exit 1
fi

if ! [[ -f angels_10.sh ]]; then
    # if there is only take off script check out this repo, get the reminding scripts
    git clone git@github.com:yanganto/parachutes.git --depth=1
    git submodule init
    git submodule update
    cd parachutes 
fi

sh angels_10.sh
