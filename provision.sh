#!/bin/bash

# SET HOST NAMES FOR IP ADDRESSES
echo "[GENERAL] Step 1 - Setting host names"
cat >>/etc/hosts<<EOF
172.42.42.100 master.inventory-manager.com master
172.42.42.101 worker1.inventory-manager.com worker1
172.42.42.102 worker2.inventory-manager.com worker2
EOF

# INSTALL DOCKER
echo "[GENERAL] Step 2 - Installing Docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# UPDATE DOCKER
sudo apt-get update
sudo apt-get upgrade docker-engine

# ENABLE DOCKER ??
# START DOCKER ??

# DISABLE SWAP
echo "[GENERAL] Step 3 - Disabling SWAP"
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

# INSTALL KUBERNETES WITH KUBEADM
echo "[GENERAL] Step 4 - Installing Kubernetes"
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# ENABLE SSH PASSWORD AUTH
echo "[GENERAL] Step 5 - Enabling SSH password authentication"
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl reload sshd
#echo "root:kubeadmin" | sudo chpasswd
#echo "export TERM=xterm" >> /home/vagrant/.bashrc
