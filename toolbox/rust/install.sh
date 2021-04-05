#!/bin/bash

# install neovim nightly
dnf copr enable agriffis/neovim-nightly
dnf install -y neovim python3-neovim

# rust prerequisites
dnf install -y gcc
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
