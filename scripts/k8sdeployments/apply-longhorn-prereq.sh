#!/bin/bash

### some things about the nodes will need to be changed to function properly

## Notice! this is meant to be executed for nodes you plan to run longhorn systems on, aka not master

# enables some modules for longhorn

cat <<EOF | sudo tee /etc/modules-load.d/longhorn.conf
iscsi_tcp
dm_crypt
EOF

sudo modprobe -a iscsi_tcp

sudo systemctl enable iscsid
sudo systemctl start iscsid

# disables multipathd since it conflicts with longhorn

sudo systemctl disable multipathd.service
sudo systemctl disable multipathd.socket

sudo systemctl stop multipathd.service
sudo systemctl stop multipathd.socket

# installs nfs-common via apt

sudo apt -y install nfs-common
