#!/bin/bash

helm repo add nvidia https://helm.ngc.nvidia.com/nvidia && helm repo update

helm install --wait --generate-name -n gpu-operator --create-namespace nvidia/gpu-operator --version=v24.9.0
