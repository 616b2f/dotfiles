#!/bin/bash

rsync -r ~/.config/git/config ./.config/git/config

folders=".config/helix/ \
.config/sway/ \
.config/waybar/ \
.config/alacritty/ \
.config/nvim/ \
.config/dive/ \
.config/omnisharp/ \
.config/xdg-desktop-portal-wlr/ \
.bashrc.d/ \
"

for folder in $folders
do
    if [ -d "$HOME/$folder" ]; then
        rsync -r --mkpath "$HOME/$folder" "./$folders"
    fi
done
