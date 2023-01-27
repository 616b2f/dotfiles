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
wlroots \
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

# needed for kind rootless (see https://kind.sigs.k8s.io/docs/user/rootless/)
mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee  /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=yes
EOF
sudo systemctl daemon-reload

cat <<EOF > /etc/modules-load.d/iptables.conf
ip6_tables
ip6table_nat
ip_tables
iptable_nat
EOF
