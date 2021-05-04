#!/usr/bin/env nu

let hostname = $(sys | get host.name)
let nixversion = $(nix-env --version)

build-string "===> Angels  9 " $(char nl)
build-string "     Setup config for alacritty" $(char nl)

if $hostname != "Windows" {mkdir ~/.config/alacritty} {}
if $hostname != "Windows" {cp alacritty.yml ~/.config/alacritty/} {}

build-string "     Setup personal script" $(char nl)
if $hostname != "Windows" {cp -r ./bin ~/.usr/} {}

if $nixversion =~ "nix-env" {build-string "     Setup nix user packages" $(char nl)} {}
if $nixversion =~ "nix-env" {cp -r nixpkgs ~/.config} {}
if $nixversion =~ "nix-env" {nix-env -iA nixos.find-cursor nixos.nix-folder2channel} {}

# sys | if $it.host.name == "Darwin" {nix-env -iA nixpkgs.find-cursor nixpkgs.nix-folder2channel} {}

# TODO: windows no allow script to create folder in appdata ?
# sys | if $it.host.name == "Windows" {mkdir `{{$nu.env.APPDATA}}\alacritty`} {}
# sys | if $it.host.name == "Windows" {cp alacritty.yml `{{$nu.env.APPDATA}}\alacritty`} {}

