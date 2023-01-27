#!/bin/bash

if [ -f /run/.toolboxenv ]; then
    alias podman="flatpak-spawn --host podman"
fi

