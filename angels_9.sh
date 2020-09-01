#!/usr/bin/env nu

# Copy the config files used in cli
format "===> Angels  9 {$(char newline)}"
format "     Setup config for alacritty{$(char newline)}"
sys | if $it.host.name == "Linux" {mkdir ~/.config/alacritty} {}
sys | if $it.host.name == "Linux" {cp alacritty.yml ~/.config/alacritty/} {}
# sys | if $it.host.name == "Darwin" {} {}
# TODO: windows no allow script to create folder in appdata ?
# sys | if $it.host.name == "Windows" {mkdir `{{$nu.env.APPDATA}}\alacritty`} {}
# sys | if $it.host.name == "Windows" {cp alacritty.yml `{{$nu.env.APPDATA}}\alacritty`} {}

format "     Setup personal script{$(char newline)}"
sys | if $it.host.name == "Linux" {cp -r ./bin ~/} {}
