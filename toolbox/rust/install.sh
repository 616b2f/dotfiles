#!/bin/bash

# copy additional repos
sudo cp ../../yum.repos.d/* /etc/yum.repos.d/

sudo dnf update

# wl-clipboard also needed for copy from inside neovim
sudo dnf install -y wl-clipboard

# install neovim nightly
sudo dnf copr enable agriffis/neovim-nightly
# telescope prerequisites
sudo dnf install -y ripgrep
sudo dnf install -y neovim python3-neovim

# rust prerequisites
sudo dnf install -y gcc
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install golang tooling
sudo dnf install -y golang

# dependecy for wally-cli
#sudo dnf install -y libusb
#go get -u github.com/zsa/wally-cli
