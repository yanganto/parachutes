#!/usr/bin/env nu

# Build up command line developing environment
format "===> Angels  8 - gitui, gitconfig, developing hooks {$(char newline)}"

# setup config for gitconfig
sys | if $it.host.name != "Windows" {cp gitconfig ~/.gitconfig } {}

# setup key config for gitui
sys | if $it.host.name == "Linux" {cp key_config.ron ~/.config/gitui/ } {}
sys | if $it.host.name == "Darwin" {cp key_config.ron "~/Library/Application Support/gitui/key_config.ron"} {}

# update default hooks
sys | if $it.host.name != "Windows" {cp -r direnv ~/.config/} {}
sys | if $it.host.name == "Linux" {sed -i "s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
sys | if $it.host.name == "Darwin" {perl -i -pe"s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
sys | if $it.host.name != "Windows" {cp -r template ~/.config/} {}
sys | if $it.host.name != "Windows" {date format "%s"  | get formatted | save -r ~/.config/template/version} {}
