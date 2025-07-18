echo "Building Worker Node..."

# Worker nodes seem to open a lot of files to changing these parameters
# Allows more files to be open
echo "fs.inotify.max_user_watches=524288" | sudo tee -a /etc/sysctl.conf
echo "fs.inotify.max_user_instances=8192" | sudo tee -a /etc/sysctl.conf

sudo sysctl -p

echo "Installation finished!"
echo "Run the following on the master node and paste the result to the worker nodes: kubeadm token create --print-join-command"
echo "Please reboot the worker node, as I'm unsure if some specific things may need it to take full effect."
