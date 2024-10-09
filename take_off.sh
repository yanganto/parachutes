#!/usr/bin/env sh

echo "===> Take Off - download and init repos"
if ! [[ -f angels_10.sh ]]; then
    # if there is only take off script check out this repo, get the reminding scripts
    git clone https://github.com/yanganto/parachutes.git --depth=1
    cd parachutes
fi

git submodule init
git submodule update
git submodule foreach --recursive git pull origin master

sh angels_10.sh
sh angels_9.sh
