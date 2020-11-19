#!/usr/bin/env sh

# Build up a uniform shell and terminal
echo "===> Angels 10 - rustfmt clippy nu alacritty"

rustup default nightly

rustup component add rustfmt
rustup component add clippy

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    mkdir -p ~/.local/bin
    mkdir -p ~/.cargo/bin
    mkdir -p ~/.usr/bin
    mkdir -p ~/.config/template

    if ! [[ `which nu` ]]; then
        cargo install nu --root
    fi
    if ! [[ `which alacritty` ]]; then
        cargo install alacritty
    fi
    if ! [[ `which s3rs` ]]; then
        cargo install s3rs
    fi

    # TODO install/make nu-shell plugin for checksum

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Handle nu alacritty for mac"
else
    echo "Unknown operating system"
fi

PATH=$PATH:$(realpath ~/.usr/bin):$(realpath ~/.cargo/bin):$(realpath ~/.cargo/bin)
echo $PATH

cp zshrc ~/.zshrc

# Set up terminal config and script
nu angels_9.sh

# Set up git developing tool
nu angels_8.sh

# Set up text editor
nu angels_7.sh

# Set up windows manager
nu angels_6.sh
