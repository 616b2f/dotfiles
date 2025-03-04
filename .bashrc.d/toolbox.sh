#!/bin/bash

alias tb=toolbox
alias tbe="toolbox enter"

if [ -f /run/.toolboxenv ]; then
    alias podman="flatpak-spawn --host podman"

    # aliases for container
    export PATH=$PATH:~/.toolbox/bin/
    export PATH=~/.local/tb-bin:$PATH
    export PATH=$PATH:~/.luarocks/bin/
    # export rootless user socket as DOCKER_HOST
    export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
    # disable ryuk it does not work with podman unfortunately
    # see (https://github.com/testcontainers/moby-ryuk/issues/23)
    export TESTCONTAINERS_RYUK_DISABLED=true

    #############################################
    # configure dotnet
    #############################################
    # don't send telementry data for dotnet tools
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    #export PATH=~/.dotnet/:$PATH
    export PATH=$PATH:~/.dotnet/tools
    # set omnisharp config dir
    export OMNISHARPHOME=$HOME/.config/omnisharp/

    #############################################
    # configure java
    #############################################
    if [ -x "$(command -v javac)"  ]; then
      export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
      export PATH=$PATH:$JAVA_HOME/bin
      export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
    fi
fi
