### This enables some modules on the machine needed for Kubernetes

echo "Adding modules..."

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe -a overlay br_netfilter
