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
    # TODO install/make nu-shell plugin for checksum

elif [[ "$OSTYPE" == "darwin"* ]]; then
    mkdir -p ~/.config/template
else
    echo "Unknown operating system"
fi

if ! [[ `which nu` ]]; then
    cargo install nu
fi
if ! [[ `which alacritty` ]]; then
    cargo install alacritty
fi

PATH=$PATH:$(realpath ~/.usr/bin):$(realpath ~/.cargo/bin):$(realpath ~/.cargo/bin)
echo $PATH

ln -s zshrc ~/.zshrc
ln -s fzf.zsh ~/.fzf.zsh
