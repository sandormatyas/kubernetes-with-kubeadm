#!/bin/bash

# INITIALIZE K8S CLUSTER
echo "[MASTER] Step 1 - Initializing Kubernetes Cluster"
sudo kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU

# COPY ADMIN CONFIG
echo "[MASTER] Step 2 - Copying admin config to Vagrant user"
mkdir /home/vagrant/.kube
sudo cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# DEPLOYING FLANNEL NETWORK
echo "[MASTER] Step 3 - Deploying flannel network"
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
sed -i 's/- --kube-subnet-mgr/- --kube-subnet-mgr\n        - --iface=eth1/' kube-flannel.yml
su - vagrant -c "kubectl create -f kube-flannel.yml"

# GENERATE JOIN COMMAND
echo "[MASTER] Step 4 - Generate join command to joincluster.sh"
kubeadm token create --print-join-command > joincluster.sh

# ADD DASHBOARD SERVICES
su - vagrant -c "kubectl apply -f dashboard.yaml"
