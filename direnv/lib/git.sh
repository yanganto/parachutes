#!/usr/bin/env sh

log() {
  echo -e "\e[38;5;82m$1\e[0m"
}

log_err() {
  echo -e "\e[38;5;202m$1\e[0m"
}

if [ -e .git ]; then
    onefetch
    if [ ! -f .git/hooks/pre-commit ] \
        || [ $(cat .git/hooks/version || echo 0) -lt __DROP_TIMESTMP ]; then
        log "Update pre-commit script"
        cp ~/.config/template/pre-commit .git/hooks/
        cp ~/.config/template/version .git/hooks/
    fi
fi
