#!/bin/bash
export TMPDIR=`mktemp -d`

VERSION="3.1.240"
curl -Lo $TMPDIR/jx-cli.tar.gz "https://github.com/jenkins-x/jx-cli/releases/download/v${VERSION}/jx-cli-linux-amd64.tar.gz"
tar -xzf  $TMPDIR/jx-cli.tar.gz -C $TMPDIR

sudo install $TMPDIR/jx /usr/local/bin
