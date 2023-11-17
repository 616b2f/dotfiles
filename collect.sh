#!/bin/bash

source ./shared-env.sh

rsync -r ~/.config/git/config ./.config/git/config

for folder in $folders
do
    if [ -d "$HOME/$folder" ]; then
        echo "sync: $folder"
        rsync -rv --mkpath "$HOME/$folder/" "$folder"
    fi
done
