#!/bin/bash

# copy additional repos
cp ./yum.repos.d/* /etc/yum.repos.d/

rpm-ostree update

# fedora silverblue packages
$PACKAGES="code \
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
swaylock \
bemenu \
j4-dmenu-desktop \
xdg-desktop-portal-wlr \
waybar \
wl-clipboard \
"

rpm-ostree install $PACKAGES

# get docker to work on fedora
# for more info see https://fedoramagazine.org/docker-and-fedora-32/
sudo firewall-cmd --permanent --zone=trusted --add-interface=docker0
sudo firewall-cmd --permanent --zone=FedoraWorkstation --add-masquerade
