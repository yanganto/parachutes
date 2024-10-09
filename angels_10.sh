#!/usr/bin/env sh

echo "===> Angels 10 - Shells"

ln zshrc ~/.zshrc
ln fzf.zsh ~/.fzf.zsh

mkdir -p ~/.usr/bin
ln ./bin/monitor ~/.usr/bin/monitor
ln ./bin/move ~/.usr/bin/move
