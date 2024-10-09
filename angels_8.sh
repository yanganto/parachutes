#!/usr/bin/env bash
set -e

# Build up command line developing environment
echo "===> Angels  8 - gitui, gitconfig, developing hooks "

# setup config for gitconfig
ln gitconfig ~/.gitconfig

mkdir -p ~/.config/gitui
ln gitui/key_bindings.ron ~/.config/gitui/key_bindings.ron

# TODO Setup github pre commit check
