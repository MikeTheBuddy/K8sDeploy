#!/bin/bash

# Define the path to the deploy files
DEPLOYFILE=$PWD"/scripts/k8snodeprep"

### Change the working directory
if [ -d "$DEPLOYFILE" ]; then
    cd "$DEPLOYFILE" || { echo "ERROR: Failed to switch to directory $DEPLOYFILE."; exit 1; }
else
    echo "ERROR: Directory $DEPLOYFILE does not exist."
    exit 1
fi

# Displays help/usage menu
usage() {
    echo "Usage: sudo bash $0 [--type NODETYPE] [--reboot] [--help]"
    echo "  --type NODETYPE Specify the type of node (e.g., [Master|Worker])"
    echo "  --reboot        Specify whether the machine should reboot upon installation"
    echo "  --help          Display this help message"
}

type=""
reboot=false

while [[ $# -gt 0 ]]; do
	key="$1"

	case $key in
		--type)
			type="$2"
			shift # Move to next argument
			shift
			;;
		--reboot)
			reboot=true
			shift
			;;
		--help)
			usage
			exit 0
			;;
		*)
			echo "Unknown option: $key"
			usage
			exit 1
			;;
	esac
done


### This file calls upon all the other files
sudo bash apply-modules.sh
sudo bash apply-net-params.sh
sudo bash cr-containerd.sh
sudo bash disable-swapoff.sh
sudo bash kube-packages.sh



# Check if a node type argument is provided
if [ -z $type ]; then
    echo "ERROR: No Node Type Specified. Please specify [Master, Worker]."
    exit 1
fi

# Execute based on the node type argument
if [ "$type" = "Master" ]; then
    sudo bash master-node.sh
elif [ "$type" = "Worker" ]; then
    sudo bash worker-node.sh
else
    echo "ERROR: Node Type Not Specified or Invalid [Master, Worker]."
fi

# Reboot the machine if flag was specified
if [ "$reboot" = true ]; then
	echo "Rebooting the machine now..."
	sudo reboot
	exit 0
fi