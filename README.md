# Setting up a Kubernetes cluster with kubeadm

We set up a Kubernetes cluster with one control plane node (master) and two worker nodes.

## Setting up the nodes/VMs

First we set up three VMs in VirtualBox with the help of a Vagrantfile.

    ENV['VAGRANT_NO_PARALLEL'] = "yes"

    Vagrant.configure("2") do |config|

    config.vm.provision "shell", path: "provision.sh"

With the **VAGRANT_NO_PARALLEL** variable set to *yes* different VMs are set up after each other, one at a time. VMs are given their IP address and run the corresponding provision script on them.

The first script that we run (on all machines) is `provision.sh`. In `provision.sh` we:
 1. set host names for the IP addresses
 2. install and update docker
 3. disable swap
 4. install kubelet, kubeadm, kubectl
 5. enable ssh password auth

Steps 1, 2 and 4 are self-explanatory, we need Docker and Kubernetes for our project, however we didn't utilize host names in the end. In step **3** we disable swap because it's required by kubeadm and in step **5** we enable ssh password authentication in order to move a file with *scp* from the master node to the workers (see `joincluster.sh` later).

## Setting up the master node

In the master node we run `provision_master.sh` that:
 1. initializes the Kubernetes cluster with kubeadm init
        sudo kubeadm init --apiserver-advertise-address=172.42.42.100 \
        --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU

 Where `172.42.42.100` is the IP of the master VM.

 2. copies admin.conf to our user's home dir (*vagrant* in our case)

 This is done so kubectl can be run from the master VM. The config file could be copied to other machines to operate kubectl from there.

 3. deploys a CNI (container netrwork interface), in this case *flannel*

        wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
        sed -i 's/- --kube-subnet-mgr/- --kube-subnet-mgr\n        - --iface=eth1/' kube-flannel.yml
        su - vagrant -c "kubectl create -f kube-flannel.yml"

      This allows the nodes to connect to each other

 4. saves the kubeadm join command into a .sh (`joincluster.sh`)

  This will be copied to worker nodes and run there in order to join the cluster.

 5. adds Kubernetes Dashboard service

 Finally we add the Dashboard service with the help of `dashboard.yaml` file.

## Setting up the worker nodes

There are two steps here (in `provision_worker.sh`):
 1. installing sshpass

 This is needed for the next step.

 2. copying the script file that contains the kubeadm join command

 With the help of sshpass, the `joincluster.sh` created on the master node in a previous step is copied to the given worker and it's executed.

---

At this point the cluster is ready and we could create deployments and services with kubectl.

## Connecting to Kubernetes Dashboard

In order to be able to connect to Dashboard in browser we need to do some more steps.

    kubectl create serviceaccount <account name>

Create a serviceaccount with a chosen name.

    kubectl create clusterrolebinding dashboard-admin --clusterrole=cluster-admin --serviceaccount=default:<account name>

Bind the cluster admin role to your serviceaccount.

    kubectl get secret

List secrets and look for the one with your account name.

    kubectl describe secret <secret name>

Copy the token that shows when you describe your secret, this will be needed when logging in to the dashboard in browser.

    kubectl get services -n kubernetes-dashboard

Look for the dashboard's NodePort (the one in the 30000 range) and open `https://<host-ip>:<dashboard-port>` (e.g. `https://172.42.42.100:32486` in my case) and enter the token you copied in the previous step.

Now you should be able to create deployments, services and manage your cluster from the Dashboard.

**Note**: Google Chrome won't open the Dashboard because of the unsecure connection, we used Firefox.
