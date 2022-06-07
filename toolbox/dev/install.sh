#!/bin/bash

# copy additional repos
sudo cp ../../yum.repos.d/* /etc/yum.repos.d/

sudo dnf update -y

# wl-clipboard also needed for copy from inside neovim
sudo dnf install -y wl-clipboard

# install luarocks (package manager for lua)
# and stuff needed for nvim lua plugin development
sudo dnf install -y luarocks compat-lua-devel gcc-c++

# install vusted (for unitests of nvim lua plugins)
luarocks --lua-version=5.1 install vusted

# treesitter prerequisites
sudo dnf install -y gcc libstdc++-static

# install neovim nightly
sudo dnf copr enable agriffis/neovim-nightly -y

# telescope prerequisites
sudo dnf install -y ripgrep jq fd-find
sudo dnf install -y neovim python3-neovim

# update plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# install rust
# rust prerequisites
sudo dnf install -y gcc
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

# install golang tooling
sudo dnf install -y golang

# install dotnet sdk
sudo dnf install -y dotnet-sdk-6.0

# dependecy for wally-cli
#sudo dnf install -y libusb
#go get -u github.com/zsa/wally-cli

# patched font with icons
sudo dnf install -y fontconfig
TMP_DIR=$(mktemp -d)
FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
curl -Lo $TMP_DIR/DejaVuSansMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip
mkdir -pv $FONT_DIR
unzip -od $FONT_DIR/ $TMP_DIR/DejaVuSansMono.zip
fc-cache -vf "$FONT_DIR"
