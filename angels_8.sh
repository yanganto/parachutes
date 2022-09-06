#!/usr/bin/env bash

# Build up command line developing environment
echo "===> Angels  8 - gitui, gitconfig, developing hooks "

# setup config for gitconfig
cp gitconfig ~/.gitconfig 

# setup key config for gitui
mkdir -p ~/.config/gitui/ 
cp key_config.ron ~/.config/gitui/ 

# update default git hooks
cp -r direnv ~/.config/
sed -i "s/__DROP_TIMESTMP/\(date +%s\)/" ~/.config/direnv/lib/git.sh
cp -r template ~/.config/

# if $hostname == "Darwin" {perl -i -pe"s/__DROP_TIMESTMP/\(date +%s\)/" ~/.config/direnv/lib/git.sh} {}
