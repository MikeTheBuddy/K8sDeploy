#!/bin/bash

### This file calls upon all the other files

sudo bash apply-modules.sh
sudo bash apply-net-params.sh
sudo bash cr-containerd.sh
sudo bash disable-swapoff.sh
sudo bash kube-packages.sh

if [$1 -eq "Master"]; then
	sudo bash master-node.sh
elif [$1 -eq "Worker"]; then
	sudo bash worker-node.sh
