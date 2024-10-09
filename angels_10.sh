#!/usr/bin/env sh

echo "===> Angels 10 - Shells"

mkdir -p ~/.cargo/bin
mkdir -p ~/.usr/bin

PATH=$PATH:$(realpath ~/.usr/bin):$(realpath ~/.cargo/bin)
echo $PATH

ln zshrc ~/.zshrc
ln -s fzf.zsh ~/.fzf.zsh

ln -s ./bin ~/.usr/
