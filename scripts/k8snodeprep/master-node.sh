
# We want to install some additional smaller things to help with the cluster
echo "Building Master Node..."


# Installs helm
curl -L https://get.helm.sh/helm-v3.16.2-linux-amd64.tar.gz > helm-v3.16.2-linux-amd64.tar.gz

tar -zxvf helm-v3.16.2-linux-amd64.tar.gz

sudo mv linux-amd64/helm /usr/local/bin/helm


# Installs kustomize
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

sudo mv kustomize /usr/bin/kustomize


# Installs Knative CLI
curl -L https://github.com/knative/client/releases/download/knative-v1.16.0/kn-linux-amd64 > kn-linux-amd64

mv kn-linux-amd64 kn

sudo chmod +x kn

sudo mv kn /usr/local/bin

echo "Installation Finished!"
