#!/usr/bin/env sh

echo "===> Angels 10 - Shells"

rm -rf ~/.zshrc
ln zshrc ~/.zshrc

rm -rf ~/.fzf.zsh
ln fzf.zsh ~/.fzf.zsh

mkdir -p ~/.usr/bin
ln ./bin/monitor ~/.usr/bin/monitor
ln ./bin/move ~/.usr/bin/move
