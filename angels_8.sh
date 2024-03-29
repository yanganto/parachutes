#!/usr/bin/env bash
set -e

# Build up command line developing environment
echo "===> Angels  8 - gitui, gitconfig, developing hooks "

# setup config for gitconfig
ln -s gitconfig ~/.gitconfig

# setup key config for gitui
gitui_version=$(gitui --version | awk '{print $2}' | awk -F. '{ print $1"."$2}')
mkdir -p ~/.config/gitui/
if [ $gitui_version  == "0.16" ]; then
    ln -s gitui/key_config.$gitui_version.ron ~/.config/gitui/key_config.ron
else
    # aftrer 0.19
    ln -s gitui/key_bindings.ron ~/.config/gitui/key_bindings.ron
fi

# update default git hooks
ln -s -r direnv ~/.config/
sed -i "s/__DROP_TIMESTMP/\(date +%s\)/" ~/.config/direnv/lib/git.sh
ln -s template ~/.config/
