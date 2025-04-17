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

Download the repository from Github

```
git clone https://github.com/MikeTheBuddy/K8sDeploy.git
```

Enter the repository

```
cd K8sDeploy
```


The next following instructions depend on if it's a worker or master node


For deploying to a master node, enter the following

```
sudo bash scripts/k8sdeploy.sh --master --reboot
```

For deploying to a worker node, enter the following
```
sudo bash scripts/k8sdeploy.sh --worker --reboot
```

The **--master** flag adds some CLI items to the master node to work with, while the **--worker** flag changes some system flags to allow more files to be opened at a given time.

The **--reboot** flag reboots the machine once the scripts finish.



# Step 2: Launch The Cluster

To initialize the cluster within this setup, run the following
```
sudo kubeadm init --pod-network-cidr=192.168.0.0/16
```

**NOTICE** Do not have the cluster use the same private IP as a device on the network, as this may cause issues of the router becoming confused on where to route requests to.

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
bash scripts/k8sdeployments/apply-calico.sh
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

For this example, we are assuming we are provided with Nvidia GPUs, so we will be using the Nvidia GPU Operator to give our nodes the ability to use GPUs (Specifically Nvidia)

Running the following command will apply a script that gets the helm chart for the nvidia GPU Operator to our existing cluster
```
bash scripts/k8sdeployments/apply-nvidia.sh
```

Nodes should get automatically labeled based on what nvidia GPU is on the node and updated with the number of gpus they can provide.

To see these labels you can run the following command and inspect the output for anything nvidia related.
```
kubectl describe nodes 
```

# Step 6: Add a storage provisioner to the cluster

Currently, the cluster cannot actually provision persistent volumes (PVs) and satisfy persistent volume claims (PVCs). We will use a default installation of longhorn for now. However, some prep will be required to get longhorn to work on the cluster.

For the worker nodes we would like to have storage provisioned to, run the following command on each of the desired worker nodes.
```
bash scripts/k8sdeployments/apply-longhorn-prereq.sh
```

After this is applied, we need to put the longhorn deployment on the cluster itself
```
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.8.1
```

After some time, this should apply longhorn to the cluster and serve PVCs that request the longhorn storage type for their PVs.

# Step 7: Add an internal loadbalancer to the cluster itself

Since this is meant to be a baremetal installation, we need to establish our own internal loadbalancer to handle pushing services out from the cluster. TODO