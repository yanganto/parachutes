#!/usr/bin/env sh

echo "===> Angels 10 - Setup Z shell and utils"

rm -rf ~/.zshrc
ln zshrc ~/.zshrc

if command -v fzf &> /dev/null; then
    echo "fzf detected"
    ln fzf.zsh ~/.fzf.zsh
fi

if command -v zoxide &> /dev/null; then
    echo "zoxide detected"
    zoxide init zsh > ~/.zoxide.zsh
fi
if command -v mcfly &> /dev/null; then
    echo "mcfly detected"
    mcfly init zsh > ~/.mcfly.zsh
fi

mkdir -p ~/.usr/bin
ln ./bin/monitor ~/.usr/bin/monitor
ln ./bin/move ~/.usr/bin/move
