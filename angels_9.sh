#!/usr/bin/nu

# Copy the config files used in cli
echo "===> Angels  9 - "

# Setup config for alacritty
sys | if $it.host.name == "Linux" {mkdir ~/.config/alacritty} {}
sys | if $it.host.name == "Linux" {cp alacritty.yml ~/.config/alacritty/} {}
# sys | if $it.host.name == "Darwin" {} {}
# TODO: windows no allow script to create folder in appdata ?
# sys | if $it.host.name == "Windows" {mkdir `{{$nu.env.APPDATA}}\alacritty`} {}
# sys | if $it.host.name == "Windows" {cp alacritty.yml `{{$nu.env.APPDATA}}\alacritty`} {}

# Setup personal script
sys | if $it.host.name == "Linux" {cp -r ./bin ~/bin} {}
