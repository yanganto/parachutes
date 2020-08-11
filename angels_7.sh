#!/usr/bin/nu

# Setup script for window manager
echo "===> Angels  7 - text editor"

sys | if $it.host.name == "Linux" {cp -r ./nvim ~/.config/nvim} {}
