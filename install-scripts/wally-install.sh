#!/bin/bash

rpm-ostree install libusb

VERSION=2.0.0

curl -O "https://github.com/zsa/wally-cli/releases/download/$VERSION-linux/wally-cli"

install wally-cli

# setup rules for moonlander keyboard
cat << EOF > /etc/udev/rules.d/50-wally.rules 
# STM32 rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", \
    MODE:="0666", \
    SYMLINK+="stm32_dfu"
EOF

groupadd plugdev
# if the above not work
# grep -E '^plugdev:' /usr/lib/group >> /etc/group
usermod -aG plugdev $USER
