#!/usr/bin/nu

# Build up command line developing environment
echo "===> Angels  8 - gitui, gitconfig"

# setup config for gitconfig
sys | if $it.host.name == "Linux" {cp gitconfig ~/.gitconfig } {}
