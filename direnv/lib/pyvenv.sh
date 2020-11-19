#!/usr/bin/env sh
if [ -e pyvenv.cfg ]; then
    log "load python virtual environment"
    source bin/activate
fi
