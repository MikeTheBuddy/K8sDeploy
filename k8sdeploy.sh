#!/bin/bash

### This section will install some networking stuff that will help the cluster

sudo apt update

# Installs runc for us
sudo apt install runc



### This section collects the kubelet kubeadm and kubectl packages we want
echo "Preparing Kubectl Kubeadm and Kubelet packages..."

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable --now kubelet

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

### This adjusts some network settings on the machine to ensure the kubelet can work

echo "Adjusting Networking Settings..."

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe -a overlay br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


### This section disables swapoff since kubelet throws a fit about it
echo "Disabling Swapoff..."

# Turn off swap
sudo swapoff -a

# Disable swap completely
sudo sed -i -e '/swap/d' /etc/fstab

### TODO
clear

echo "Core Installation Complete"

if [ "$1" == "master" ]; then
  # We want to install some additional smaller things to help with the cluster
  echo "Building Master Node..."


  # Installs helm
  curl -L https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz > helm-v3.16.2-linux-amd64.tar.gz

  tar -zxvf helm-v3.16.2-linux-amd64.tar.gz

  sudo mv linux-amd64/helm /usr/local/bin/helm


  # Installs kustomize
  curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

  sudo mv kustomize /usr/bin/kustomize


  # Installs Knative
  curl -L https://github.com/knative/client/releases/download/knative-v1.16.0/kn-linux-amd64 > kn-linux-amd64

  mv kn-linux-amd64 kn

  sudo chmod +x kn

  sudo mv kn /usr/local/bin

  clear

  echo "Installation Finished!"
  echo "Please initalize a cluster with the follow command... [sudo kubeadm init --pod-network-cidr=192.168.0.0/16]"


else
  echo "Building Worker Node..."

  # Worker nodes seem to open a lot of files to changing these parameters
  # Allows more files to be open
  echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
  echo "fs.inotify.max_user_instances=8192" | sudo tee -a /etc/sysctl.conf

  sudo sysctl -p

  echo "Installation finished!"
  echo "Run the following on the master node and paste the result to the worker nodes: kubeadm token create --print-join-command"
  echo "Please reboot the worker node since there was already a version of containerd on it and a reboot is necessary for the changes to take effect"
fi
