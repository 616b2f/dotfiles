# enable blobstar (**)
shopt -s globstar

# set neovim as default editor
export EDITOR=nvim

# increase bash command history size
export HISTSIZE=20000
export HISTFILESIZE=20000

export PATH=~/.local/bin:$PATH

# don't send telementry data for dotnet tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=$PATH:~/.dotnet/tools

# use podman for kind
export KIND_EXPERIMENTAL_PROVIDER=podman

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias tb=toolbox
alias tbe="toolbox enter"

# setup keybindings for fzf
if [ -x "$(command -v fzf)"  ]; then
    source /usr/share/fzf/shell/key-bindings.bash
fi

. "$HOME/.cargo/env"

if [ -x "$(command -v kubectl)"  ]; then
    alias k=kubectl
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

if [ -x "$(command -v info)"  ]; then
    alias info="info --vi-keys" # enable vi bindings
fi
