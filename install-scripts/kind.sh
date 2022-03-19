#!/bin/bash
export TMPDIR=/tmp

VERSION="0.11.1"
curl -Lo $TMPDIR/kind "https://kind.sigs.k8s.io/dl/v${VERSION}/kind-linux-amd64"
sudo install $TMPDIR/kind ~/.local/bin
