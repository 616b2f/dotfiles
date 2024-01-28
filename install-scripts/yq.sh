#!/bin/bash -e
VERSION=4.40.5
curl -L https://github.com/mikefarah/yq/releases/download/v${VERSION}/yq_linux_amd64 \
     -o ~/.local/bin/yq
chmod +x ~/.local/bin/yq
