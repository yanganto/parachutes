#!/usr/bin/env nu
format "===> Angels  9 {$(char newline)}"
format "     Setup config for alacritty{$(char newline)}"

sys | if $it.host.name == "Linux" {mkdir ~/.config/alacritty} {}
sys | if $it.host.name == "Linux" {cp alacritty.yml ~/.config/alacritty/} {}

format "     Setup personal script{$(char newline)}"
sys | if $it.host.name == "Linux" {cp -r ./bin ~/.usr/} {}

sys | if $it.host.version =~ "NixOS" {format "     Setup nix user packages{$(char newline)}"} {}
sys | if $it.host.version =~ "NixOS" {cp -r nixpkgs ~/.config} {}
sys | if $it.host.version =~ "NixOS" {nix-env -iA nixos.find-cursor nixos.nix-folder2channel} {}

# sys | if $it.host.name == "Darwin" {nix-env -iA nixpkgs.find-cursor nixpkgs.nix-folder2channel} {}

# TODO: windows no allow script to create folder in appdata ?
# sys | if $it.host.name == "Windows" {mkdir `{{$nu.env.APPDATA}}\alacritty`} {}
# sys | if $it.host.name == "Windows" {cp alacritty.yml `{{$nu.env.APPDATA}}\alacritty`} {}

