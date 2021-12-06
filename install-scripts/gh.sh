#!/bin/bash -e

VERSION=2.3.0
curl -Lo gh.tar.gz https://github.com/cli/cli/releases/download/v${VERSION}/gh_${VERSION}_linux_amd64.tar.gz
tar xvf gh.tar.gz --strip-components 2 -C ~/.local/bin/ gh_${VERSION}_linux_amd64/bin/gh
rm gh.tar.gz
