#!/bin/bash

# wl-clipboard also needed for copy from inside neovim
dnf install -y wl-clipboard

# install neovim nightly
dnf copr enable agriffis/neovim-nightly
dnf install -y neovim python3-neovim

# rust prerequisites
dnf install -y gcc
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install golang tooling
#sudo dnf install -y golang

# dependecy for wally-cli
#sudo dnf install -y libusb
#go get -u github.com/zsa/wally-cli
