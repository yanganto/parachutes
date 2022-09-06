#!/usr/bin/env bash

echo "===> Angels  9 "
echo "     Setup config for alacritty"

mkdir -p ~/.config/alacritty
cp alacritty.yml ~/.config/alacritty/

echo "     Setup personal script"
cp -r ./bin ~/.usr/
