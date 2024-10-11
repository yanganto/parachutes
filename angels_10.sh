#!/usr/bin/env sh

echo "===> Angels 10 - Setup Z shell and utils"

rm -rf ~/.zshrc
ln zshrc ~/.zshrc

rm -rf ~/.fzf.zsh
ln fzf.zsh ~/.fzf.zsh

mkdir -p ~/.usr/bin
ln ./bin/monitor ~/.usr/bin/monitor
ln ./bin/move ~/.usr/bin/move

if command -v zoxide &> /dev/null; then
    echo "zoxide detected"
    zoxide init zsh
fi
