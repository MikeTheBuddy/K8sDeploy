#!/bin/bash
helm repo add projectcalico https://docs.tigera.io/calico/charts

kubectl create namespace tigera-operator

helm install calico projectcalico/tigera-operator --version v3.29.0 --namespace tigera-operator

