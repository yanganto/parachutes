#!/usr/bin/env nu

# Setup script for window manager
format "===> Angels  7 - text editor{$(char newline)}"

sys | if $it.host.name == "Linux" || $it.host.name == "Darwin"  {cp -r ./nvim ~/.config/} {}
