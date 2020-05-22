#!/bin/bash

# INSTALL SSHPASS
echo "[WORKER] Step 1 - Installing sshpass to ssh-copy join command"
sudo apt-get install -y sshpass

# JOINING CLUSTER
echo "[WORKER] Step 2 - Joining Kubernetes cluster"
if sshpass -p "vagrant" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.inventory-manager.com:joincluster.sh joincluster.sh
then sudo bash joincluster.sh
else
  if sudo su - vagrant -c "sshpass -p "vagrant" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no master.inventory-manager.com:joincluster.sh joincluster.sh"
  then sudo bash joincluster.sh
  else echo "Error! Could not copy joincluster.sh."
  fi
fi
