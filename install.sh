#!/bin/bash

source ./shared-env.sh

# copy additional repos
sudo cp ./yum.repos.d/* /etc/yum.repos.d/

rpm-ostree update

rpm-ostree install --allow-inactive --idempotent $packages

# enable ntp sync for date and time
timedatectl set-ntp yes

flatpak install com.google.Chrome
flatpak install org.flameshot.Flameshot

# needed for kind rootless (see https://kind.sigs.k8s.io/docs/user/rootless/)
sudo mkdir -p /etc/systemd/system/user@.service.d
cat <<EOF | sudo tee  /etc/systemd/system/user@.service.d/delegate.conf
[Service]
Delegate=yes
EOF
sudo systemctl daemon-reload

# cat <<EOF > /etc/modules-load.d/iptables.conf
# ip6_tables
# ip6table_nat
# ip_tables
# iptable_nat
# EOF

for config in $configs
do
    if [ -d "./$config" ]; then
        rsync -r --mkpath "./$config/" "$HOME/$config"
    fi
done
