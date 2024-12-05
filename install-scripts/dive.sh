VERSION=0.12.0
curl -o dive.tar.gz -L "https://github.com/wagoodman/dive/releases/download/v${VERSION}/dive_${VERSION}_linux_amd64.tar.gz"
tar xvf dive.tar.gz -C ~/.local/bin/ dive
rm dive.tar.gz
