#!/usr/bin/env nu

let hostname = $(sys | get host.name)

# Setup script for window manager
format "===> Angels  7 - text editor{$(char newline)}"

if $hostname != "Windows" {cp -r ./nvim ~/.config/} {}
