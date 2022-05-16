#!/bin/bash

# copy additional repos
cp ./yum.repos.d/* /etc/yum.repos.d/

rpm-ostree update

# fedora silverblue packages
PACKAGES="\
git \
git-lfs \
polkit-gnome \
google-chrome-stable \
fd-find \
ripgrep \
neovim \
tmux \
vifm \
sway \
grim \
slurp \
mako \
swaylock \
bemenu \
j4-dmenu-desktop \
xdg-desktop-portal-wlr \
waybar \
wl-clipboard \
brightnessctl \
"

rpm-ostree install --allow-inactive --idempotent $PACKAGES
