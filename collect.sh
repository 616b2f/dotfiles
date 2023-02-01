#!/bin/bash

rsync -r ~/.config/git/config ./.config/git/config
rsync -r --mkpath ~/.config/sway/ ./.config/sway/
rsync -r --mkpath ~/.config/waybar/ ./.config/waybar/
rsync -r --mkpath ~/.config/alacritty/ ./.config/alacritty/
rsync -r --mkpath ~/.config/nvim/ ./.config/nvim/
rsync -r --mkpath ~/.config/helix/ ./.config/helix/
rsync -r --mkpath ~/.config/dive/ ./.config/dive/
rsync -r --mkpath ~/.config/omnisharp/ ./.config/omnisharp/
rsync -r --mkpath ~/.config/xdg-desktop-portal-wlr/ ./.config/xdg-desktop-portal-wlr/
rsync -r --mkpath ~/.bashrc.d/ ./.bashrc.d/
