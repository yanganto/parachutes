#!/usr/bin/env nu

let hostname = $(sys | get host.name)

# Setup script for window manager
build-string "===> Angels  7 - text editor" $(char nl)

if $hostname != "Windows" {cp -r ./nvim ~/.config/} {}
