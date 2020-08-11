#!/usr/bin/nu

# Setup script for window manager
echo "===> Angels  6 - window manager"

sys | if $it.host.name == "Linux" {cp -r ./qtile ~/.config/qtile} {}
