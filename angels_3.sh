#!/usr/bin/env bash
set -e

echo "===> Angels 3 - AI Tools"
if command -v opencode --version &> /dev/null; then
    echo "Setup opencode keybinds"
    mkdir -p ~/.config/opencode
    ln -s `pwd`/opencode/tui.json ~/.config/opencode/tui.json
fi
