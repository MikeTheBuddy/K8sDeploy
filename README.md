This repo is purely for helping to automate Kubernetes deployment due to some limitations.

This is always a WIP and may be changed and modified over time



# Step 0: Before You Begin
Optional: Disable the need for sudo password

Ubuntu, the OS we are using by default, will require a password each time sudo is called.

To disable this, enter the following

```
sudo visudo
```

Within this file, add the following line to the bottom of the file if it does not exist

Replace $USER in the example with the username of the account you wish to no longer require the password to do sudo with.

```
$USER ALL=(ALL) NOPASSWD: ALL
```


Ensure that git is installed on your system by default, in the case of Ubuntu, it can be installed with the following command.
```
sudo apt install git
```

# Step 1: Setup

The next following instructions depend on if it's a worker or master node

To deploy for the master node, enter the following command and reboot
```
sudo bash scripts/k8sdeploy.sh master
```

For deploying to a worker node, enter the following and reboot
```
sudo bash scripts/k8sdeploy.sh
```

# Step 2: Launch The Cluster

To initialize the cluster within this setup, run the following
```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

After initializing a cluster, you are prompted with some additional steps run the following commands as follows.
```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

Please wait for the pods to start up, the coreDNS pods will not start up properly, this is intentional and will be handled later.

# Step 3: Install Networking Layer

For this cluster, calico will be used for the networking layer. Run the following command to set it up on the master node.
```
bash scripts/applycalico.sh
```

This will use the calico helm chart to handle all of our networking issues regarding the cluster.

# Step 4: Connect Workers To Master Node

The easiest way to set up the master node to worker nodes on the same network is by first running this command on the master node.
```
sudo kubeadm token create --print-join-command
```

This command will print out the entire command required to connect a worker node to the master node.

With this command, enter it into the worker node with sudo beforehand.

(Make sure a worker node is set up properly beforehand, refer back to step 1 if necessary)

# Step 5: Add GPUs to the cluster

WIP
