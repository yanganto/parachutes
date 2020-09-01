#!/usr/bin/env nu

# Build up command line developing environment
format "===> Angels  8 - gitui, gitconfig{$(char newline)}"

# setup config for gitconfig
sys | if $it.host.name == "Linux" {cp gitconfig ~/.gitconfig } {}
