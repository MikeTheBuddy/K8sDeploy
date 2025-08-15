## Advanced Kubeadm Join

To join a worker node on a specific IP address, you need to pass in a JoinConfiguration file to kubeadm instead.

We are running with the assumption you have more than one network card within the machine and wish to bind it to one of them in particular.

# Step 1: Find the hostname IP

Run the following command
```
hostname -I
```

This should list all hostname IPs you currently are running with, so pick the one associated with the card you wish to use. Remember that this card must be capable of reaching the api server of the cluster.

# Step 2: Generate token and get the caCertHashes

Now, we need to get some information about the cluster, assuming you have admin permissions if you've been making it up until this point, you should be able to run the following.

```
sudo kubeadm token create --print-join-command
```

You will receive the following response back, minus the placeholders.

Keep in mind the values at each of the placeholders as we will be using them.

```
sudo kubeadm join <API Server IP> --token <Join Token> --discovery-token-ca-cert-hash <sha256hash>
```

# Step 3: Create a JoinConfiguration file

Remember the values I mentioned to remember from the kubeadm token create command? Here's where they come into play. Take a look at the example file [here](example-joinconfiguration.yaml). Fill in the following blanks with those values we have discussed. When ready, run the following and replace the placeholder with the filename.

```
sudo kubeadm join --config <filename>
```

If all goes well, the node should be added to the cluster.