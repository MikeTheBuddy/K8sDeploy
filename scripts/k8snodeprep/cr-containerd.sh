#!/bin/bash

### This section installs containerd for us and prepares it for us

echo "Preparing Containerd Config..."

sudo mkdir /etc/containerd

sudo echo "version = 2

[plugins]

  [plugins.\"io.containerd.grpc.v1.cri\".containerd.runtimes.runc]

    runtime_type = \"io.containerd.runc.v2\"

    [plugins.\"io.containerd.grpc.v1.cri\".containerd.runtimes.runc.options]

      SystemdCgroup = true" > /etc/containerd/config.toml

echo "Preparing Containerd Service..."

curl -fLo containerd-1.7.23-linux-amd64.tar.gz https://github.com/containerd/containerd/releases/download/v1.7.23/containerd-1.7.23-linux-amd64.tar.gz

sudo tar Cxzvf /usr/local containerd-1.7.23-linux-amd64.tar.gz

sudo curl -fsSLo /etc/systemd/system/containerd.service https://raw.githubusercontent.com/containerd/containerd/main/containerd.service 

sudo systemctl daemon-reload

sudo systemctl enable --now containerd
