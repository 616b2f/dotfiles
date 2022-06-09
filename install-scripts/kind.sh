#!/bin/bash
export TMPDIR=/tmp

VERSION="0.14.0"
curl -Lo $TMPDIR/kind "https://kind.sigs.k8s.io/dl/v${VERSION}/kind-linux-amd64"
install $TMPDIR/kind ~/.local/bin
