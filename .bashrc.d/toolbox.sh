#!/bin/bash

alias tb=toolbox
alias tbe="toolbox enter"

if [ -f /run/.toolboxenv ]; then
    alias podman="flatpak-spawn --host podman"

    # aliases for container
    export PATH=$PATH:~/.toolbox/bin/
    export PATH=$PATH:~/.luarocks/bin/
fi

