#!/usr/bin/env nu

let hostname = $(sys | get host.name)
let nixversion = $(nix-env --version)

# Build up command line developing environment
build-string "===> Angels  8 - gitui, gitconfig, developing hooks " $(char nl)

# setup config for gitconfig
if $hostname != "Windows" {cp gitconfig ~/.gitconfig } {}

# setup key config for gitui and install gitui
if $hostname == "Windows" || {cargo install gitui} {}
if $nixversion =~ "nix-env" && $hostname == "NixOS" {nix-env -iA nixos.gitAndTools.gitui} {}
if $nixversion =~ "nix-env" && $hostname != "NixOS" {nix-env -iA nixpkgs.gitAndTools.gitui} {}

if $hostname != "Windows" {mkdir ~/.config/gitui/ } {}
if $hostname != "Windows" {cp key_config.ron ~/.config/gitui/ } {}

# update default git hooks
if $hostname != "Windows" {cp -r direnv ~/.config/} {}
if $hostname != "Windows" && $hostname != "Darwin" {sed -i "s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
if $hostname == "Darwin" {perl -i -pe"s/__DROP_TIMESTMP/$(date +%s)/" ~/.config/direnv/lib/git.sh} {}
if $hostname != "Windows" {cp -r template ~/.config/} {}
if $hostname != "Windows" {date format "%s"  | get formatted | save -r ~/.config/template/version} {}
