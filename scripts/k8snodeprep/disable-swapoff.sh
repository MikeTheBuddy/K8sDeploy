### This section disables swapoff since kubelet throws a fit about it
echo "Disabling Swapoff..."

# Turn off swap
sudo swapoff -a

# Disable swap completely
sudo sed -i -e '/swap/d' /etc/fstab
