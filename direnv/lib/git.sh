#!/usr/bin/env sh
if [ -e .git ]; then
    onefetch
    if [ ! -f .git/hooks/pre-commit ] \
        || [ $(cat .git/hooks/version || echo 0) -lt __DROP_TIMESTMP ]; then
        log "Update pre-commit script"
        cp ~/.config/template/pre-commit .git/hooks/
        cp ~/.config/template/version .git/hooks/
    fi
fi
