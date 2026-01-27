#!/usr/bin/env bash
set -e

echo "===> Angels 4 - Privacy Tools"
if command -v 1password &> /dev/null; then
    ln gitconfig.gpg ~/.gitconfig
    mkdir ~/.gnupg/
    cp gpg-agent.conf ~/.gnupg/
    cat /etc/pinentry-curses-path >> ~/.gnupg/gpg-agent.conf
fi
