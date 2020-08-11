#!/bin/sh

# Build up a uniform shell and terminal
echo "===> Angels 10 - rustfmt clippy nu alacritty"

rustup default nightly

rustup component add rustfmt 
rustup component add clippy

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    if ! [[ `which nu` ]]; then
        cargo install nu --root ~/bin
    fi 
    if ! [[ `which alacritty` ]]; then
        cargo install alacritty --root ~/bin
    fi

    # TODO isntall/make nu-shell plugin for checksum

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Handle nu alacritty for mac "
else
    echo "Unknown operating system."
fi

# Set up terminal config and script
nu angels_9.sh

# Set up git developing tool
nu angels_8.sh

# Set up text editor 
nu angels_7.sh

# Set up windows manager 
nu angels_6.sh
