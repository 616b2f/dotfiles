# enable blobstar (**)
shopt -s globstar

# set neovim as default editor
export EDITOR=nvim
# use nvim for manpages
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# increase bash command history size
export HISTSIZE=20000
export HISTFILESIZE=20000

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi
export PATH

# don't send telementry data for dotnet tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=$PATH:~/.dotnet/tools

# use podman for kind
export KIND_EXPERIMENTAL_PROVIDER=podman

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# setup keybindings for fzf
if [ -x "$(command -v fzf)"  ]; then

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

    if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
        source /usr/share/fzf/shell/key-bindings.bash
    fi
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

if [ -x "$(command -v kubectl)"  ]; then
    alias k=kubectl
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

if [ -x "$(command -v info)"  ]; then
    alias info="info --vi-keys" # enable vi bindings
fi
