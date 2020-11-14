#!/usr/bin/env nu

# Build up command line developing environment
format "===> Angels  8 - gitui, gitconfig{$(char newline)}"

# setup config for gitconfig
sys | if $it.host.name == "Linux" {cp gitconfig ~/.gitconfig } {}

# setup key config for gitui
sys | if $it.host.name == "Linux" {cp key_config.ron ~/.config/gitui/ } {}

# update default git hooks
sys | if $it.host.name == "Linux" {cp -r direnv ~/.config/} {}
sys | if $it.host.name == "Linux" {sed -i "s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
sys | if $it.host.name == "Linux" {cp -r template ~/.config/} {}
sys | if $it.host.name == "Linux" {date format "%s"  | get formatted | save -r ~/.config/template/version} {}
