#!/bin/bash
export TMPDIR=/tmp

curl -Lo $TMPDIR/skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
sudo install $TMPDIR/skaffold /usr/local/bin/
