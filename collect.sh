#!/bin/bash

rsync -r ~/.config/sway/ ./.config/sway/
rsync -r ~/.config/waybar/ ./.config/waybar/
rsync -r ~/.config/nvim/ ./.config/nvim/
rsync -r ~/.gitconfig ./.gitconfig
