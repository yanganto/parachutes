#!/usr/bin/env nu

let hostname = $(sys | get host.name)

# Build up command line developing environment
format "===> Angels  8 - gitui, gitconfig, developing hooks {$(char newline)}"

# setup config for gitconfig
if $hostname != "Windows" {cp gitconfig ~/.gitconfig } {}

# setup key config for gitui
if $hostname == "Linux" {cp key_config.ron ~/.config/gitui/ } {}
if $hostname == "Darwin" {cp key_config.ron "~/Library/Application Support/gitui/key_config.ron"} {}

# update default git hooks
if $hostname != "Windows" {cp -r direnv ~/.config/} {}
if $hostname != "Windows" && $hostname != "Darwin" {sed -i "s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
if $hostname == "Darwin" {perl -i -pe"s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
if $hostname != "Windows" {cp -r template ~/.config/} {}
if $hostname != "Windows" {date format "%s"  | get formatted | save -r ~/.config/template/version} {}
