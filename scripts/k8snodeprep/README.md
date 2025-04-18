# Shell Scripts For Node Preparation

This section of deploy scripts is for handling the individual pieces I have found that installing a cluster using kubeadm requires

## apply-modules.sh

Applies some modules that have been shown to be necessary to make a Kubernetes ready to be deloyed via kubeadm

## apply-net-params.sh

Adjusts some of the network parameters of the machine to allow the cluster to handle routing network traffic.

## cr-containerd.sh

Applies containerd along with a default configuration file to allow Kubernetes to utilize the CNI in containerd for being the primary containerization method of the node.

## disable-swapoff

This disables swapoff as the Kubelet really isn't designed to handle situations with it enabled.

## kube-packages

Installs some packages necessary for Kubernetes to function along with some CLI options associated with interacting with the cluster.

(May update this one to only install some on the master node)

## master-node.sh

This deployment installs helm, kustomize, and knative to the master node to help make deploying applications easier. This script is only meant to run on nodes you plan to have function as master nodes.

## worker-node.sh

This deployment adjusts some system parameters to allow far more files to be open at once, given the defaults for Ubuntu may result in the node maxing out how many files its allowed to keep open at once. This script is only meant to run on the worker nodes.