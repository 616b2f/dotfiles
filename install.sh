#!/bin/bash

# copy additional repos
cp ./yum.repos.d/* /etc/yum.repos.d/

rpm-ostree update

# fedora silverblue packages
PACKAGES="code \
fedora-workstation-repositories \
gnome-tweak-tool \
google-chrome-stable \
moby-engine \
git \
git-lfs \
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

rpm-ostree install $PACKAGES
