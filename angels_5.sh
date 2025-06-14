#!/usr/bin/env bash
set -e

# Setup script for File Browser
echo "===> Angels  6 - File Browser"
if command -v yazi &> /dev/null; then
    echo "yazi detected"
    ln -s `pwd`/yazi ~/.config/
fi
