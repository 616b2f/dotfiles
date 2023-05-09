#!/bin/bash
set -e -o pipefail

###
# setup additional repos
###
sudo cp ../../yum.repos.d/* /etc/yum.repos.d/

###
# update all installed packages to latest version
###
sudo dnf update -y

###
# install neovim
###
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
sudo dnf copr enable -y agriffis/neovim-nightly
#sudo dnf update -y

# telescope prerequisites
sudo dnf install -y ripgrep jq fd-find

# some of the lsp servers need npm
sudo dnf install -y nodejs

sudo dnf install -y neovim python3-neovim

# update plugins
nvim --headless -c '+Lazy! restore' +qa


###
# install helix
###
sudo dnf copr enable -y varlad/helix
sudo dnf install -y helix

###
# install wally-cli (for Moonlander firmware update)
###
#sudo dnf install -y libusb
#go get -u github.com/zsa/wally-cli

###
# go lang
###
# install golang tooling
sudo dnf install -y golang

###
# dotnet
###
# install dotnet sdk
sudo dnf install -y dotnet-sdk-6.0
# Create Dotnet Developer Certificate
dotnet dev-certs https

set +e
# disable fail on error return types
# because dotnet tool returns 1 if the tool is already installed
# Install Dotnet EF-CLI 
dotnet tool install --global dotnet-ef
# Install outdated tool
dotnet tool install --global dotnet-outdated-tool
# Install decompilation tool ilspy
#dotnet tool install --global ilspycmd
dotnet tool install -g dotnet-reportgenerator-globaltool
set -e

###
# java
###

# sudo dnf install -y java-17-openjdk-devel
# ./../../install-scripts/gradle.sh

###
# rust
###

# echo "Install rust"
# if ! [ -x "$(command -v rustup)" ]; then
#     echo "Install rust dependency: gcc"
#     sudo dnf install -y gcc
#     # install rust
#     echo "Install rustup"
#     curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
# fi

###
# install kubectl
###
if ! [ -x "$(command -v kubectl)" ]; then
    echo "Install kubectl"
    sudo dnf install -y kubectl
fi

###
# misc tooling
###
sudo dnf install -y \
    fzf \
    gh

###
# install fonts
###
# patched font with icons
sudo dnf install -y fontconfig
TMP_DIR=$(mktemp -d)
FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
mkdir -pv "$FONT_DIR"

echo "Install DejaVueSansMono font"
curl -Lo "$TMP_DIR/DejaVuSansMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/DejaVuSansMono.zip
unzip -od "$FONT_DIR/" "$TMP_DIR/DejaVuSansMono.zip"

echo "Install Droid Sans Mono font"
curl -fLo "$FONT_DIR/DroidSansMNerdFontMono-Regular.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/DroidSansMNerdFontMono-Regular.otf
echo "Refresh font cache"
fc-cache -vf "$FONT_DIR"

echo "Install GNU info command"
sudo dnf install -y info

echo "Setup mandb to be able to use 'man -k X'"
sudo mandb -c
