#!/usr/bin/env bash

echo "===> Angels  9 "
echo "     Setup config for alacritty"

mkdir -p ~/.config/alacritty
ln -s alacritty.yml ~/.config/alacritty/alacritty.yml

echo "     Setup personal script"
cp -s ./bin ~/.usr/
