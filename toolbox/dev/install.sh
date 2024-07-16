#!/bin/bash
set -e -o pipefail

###
# enable podman socket inside toolbox
###
systemctl --user --now enable podman.socket

###
# setup additional repos
###
sudo cp ./yum.repos.d/* /etc/yum.repos.d/

###
# update all installed packages to latest version
###
sudo dnf update -y --best --allowerasing

###
# install neovim
###
# wl-clipboard also needed for copy from inside neovim
sudo dnf install -y wl-clipboard

# install luarocks (package manager for lua)
# and stuff needed for nvim lua plugin development
sudo dnf install -y luarocks compat-lua compat-lua-devel gcc-c++

# install vusted (for unitests of nvim lua plugins)
# luarocks --lua-version=5.1 install vusted
luarocks --lua-version=5.1 --local install busted

# treesitter prerequisites
sudo dnf install -y gcc libstdc++-static

# needed for file-watcher implementation in neovim
sudo dnf install -y inotify-tools

# install neovim nightly
sudo dnf copr enable -y agriffis/neovim-nightly

# telescope prerequisites
sudo dnf install -y ripgrep jq fd-find

# some of the lsp servers need npm
sudo dnf install -y nodejs

sudo dnf install -y neovim python3-neovim

# update plugins
nvim --headless "+Lazy! restore" +qa

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
sudo dnf install -y dotnet-sdk-8.0
# Create Dotnet Developer Certificate
dotnet dev-certs https

# disable fail on error return types
# because dotnet tool returns 1 if the tool is already installed
# Install Dotnet EF-CLI 
dotnet tool update -g dotnet-ef
# Install outdated tool
dotnet tool update -g dotnet-outdated-tool
# Install decompilation tool ilspy
#dotnet tool update -g ilspycmd
dotnet tool update -g dotnet-reportgenerator-globaltool

###
# java
###
sudo dnf install -y java-17-openjdk-devel
# install spring boot cli
#./../../install-scripts/springboot.sh
# ./../../install-scripts/gradle.sh

###
# rust
###

echo "Install rust"
if ! [ -x "$(command -v rustup)" ]; then
    echo "Install rust dependency: gcc"
    sudo dnf install -y gcc
    # install rust
    echo "Install rustup"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable
fi

###
# setup user owned bin folder
###
mkdir -p ~/.local/bin

echo "Install yq"
../../install-scripts/yq.sh

###
# python pip (needed for azure cli extensions)
###
sudo dnf install -y python3-pip

###
# install python stuff
###
pip3 install --upgrade --user pdm
# enable bash completion for pdm
pdm completion bash | sudo tee /etc/bash_completion.d/pdm.bash-completion

###
# install kubectl
###
if ! [ -x "$(command -v kubectl)" ]; then
    echo "Install kubectl"
    sudo dnf install -y kubectl
fi

# if ! [ -x "$(command -v kubectl-krew)" ]; then
#     . ../../install-scripts/krew.sh
#
#     kubectl krew upgrade
#     # add additional indexes
#     kubectl krew index add kvaps https://github.com/kvaps/krew-index
#     kubectl krew install kubescape
# fi

###
# install krew plugins
###
echo "Install krew plugins"
if [ -x "$(command -v kubectl-krew)" ]; then
    kubectl krew install kvaps/node-shell
fi

if ! [ -x "$(command -v skaffold)" ]; then
    echo "Install skaffold"
    . ../../install-scripts/skaffold.sh -v "2.10.0"
fi

if ! [ -x "$(command -v tofu)" ]; then
    echo "Install OpenTofu"
    sudo dnf install -y tofu
fi

# kafka tooling
# sudo dnf copr enable bvn13/kcat -y
# sudo dnf install -y kcat

###
# misc tooling
###
sudo dnf install -y \
    fzf \
    gh \
    git \
    git-lfs

###
# networks tooling
###
sudo dnf install -y \
    bind-utils \
    openssl

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

echo "Setup mandb"
# setup mandb to be able to use "man -k X"
sudo mandb -c
