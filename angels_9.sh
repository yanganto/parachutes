#!/usr/bin/env nu

let hostname = $(sys | get host.name)
let nixversion = $(nix-env --version)

format "===> Angels  9 {$(char newline)}"
format "     Setup config for alacritty{$(char newline)}"

if $hostname != "Windows" {mkdir ~/.config/alacritty} {}
if $hostname != "Windows" {cp alacritty.yml ~/.config/alacritty/} {}

format "     Setup personal script{$(char newline)}"
if $hostname != "Windows" {cp -r ./bin ~/.usr/} {}

if $nixversion =~ "nix-env" {format "     Setup nix user packages{$(char newline)}"} {}
if $nixversion =~ "nix-env" {cp -r nixpkgs ~/.config} {}
if $nixversion =~ "nix-env" {nix-env -iA nixos.find-cursor nixos.nix-folder2channel} {}

# sys | if $it.host.name == "Darwin" {nix-env -iA nixpkgs.find-cursor nixpkgs.nix-folder2channel} {}

# TODO: windows no allow script to create folder in appdata ?
# sys | if $it.host.name == "Windows" {mkdir `{{$nu.env.APPDATA}}\alacritty`} {}
# sys | if $it.host.name == "Windows" {cp alacritty.yml `{{$nu.env.APPDATA}}\alacritty`} {}

