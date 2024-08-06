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

# don't send telementry data for dotnet tools
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH=$PATH:~/.dotnet/tools

# use go bin folder
PATH="$HOME/go/bin:$PATH"

# use coursier
PATH="$HOME/.local/share/coursier/bin:$PATH"

# enable new buildkit for docker (faster builds etc.)
#export DOCKER_BUILDKIT=1
# enable buildkit also for docker-compose
#export COMPOSE_DOCKER_CLI_BUILD=1
# export rootless user socket as DOCKER_HOST
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock

# add user local bin folder to path
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]
then
    PATH="$HOME/.local/bin:$PATH"
fi

# use podman for kind
export KIND_EXPERIMENTAL_PROVIDER=podman

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# make kubectl diff colored
export KUBECTL_EXTERNAL_DIFF="diff --color=always -N -u"

# setup keybindings for fzf
if [ -x "$(command -v fzf)"  ]; then
    source /usr/share/fzf/shell/key-bindings.bash

    fp() {
        local dir
        dir=$(fd -c never -t d -d 1 . ~/devel/ 2> /dev/null | fzf +m) &&
        cd "$dir"
    }

    fpn() {
        local dir
        dir=$(fd -c never -t d -d 1 . ~/devel/ 2> /dev/null | fzf +m) &&
        cd "$dir" &&
        nvim
    }

    # CTRL-M - Paste the selected file path into the command line
    # bind -m emacs-standard -x '"\C-m": custom-fzf-projects'
    # bind -m vi-command -x '"\C-m": custom-fzf-projects'
    # bind -m vi-insert -x '"\C-m": custom-fzf-projects'
fi

if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

# add krew plugins to path
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

if [ -x "$(command -v kubectl)"  ]; then
    alias k=kubectl
    source <(kubectl completion bash)
    complete -F __start_kubectl k
fi

if [ -x "$(command -v info)"  ]; then
    alias info="info --vi-keys" # enable vi bindings
fi
