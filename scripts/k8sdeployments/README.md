# Basic Deployments For Cluster

These scripts are focused on deploying specific deployments to the Kubernetes cluster once established.

## apply-calico.sh

Allows for the cluster to communicate across the network with other nodes. Kubernetes by default lacks a networking layer, so this just adds that component in.

## apply-nvidia.sh

Kubernetes by default cannot use the GPU on its machines. To get around this, the following script applies the gpu-operator deployment which grants the cluster the capability to allow Nvidia gpus to be utilized by the cluster.

## apply-metallb.sh (NOT IMPLEMENTED)

Script deploys metallb using helm charts to allow the cluster to handle internal loadbalancing. This deployment is needed only if the cluster lacks an external load balancer, which in most baremetal situations, is the case.