#!/usr/bin/env bash

let hostname = (sys | get host.name)

# Setup script for editor
echo "===> Angels  7 - text editor"
ln -s ./nvim ~/.config/nvim
