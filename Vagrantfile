# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = "yes"

Vagrant.configure("2") do |config|

  config.vm.provision "shell", path: "provision.sh"

  # K8S MASTER NODE
  config.vm.define "master" do |master|
    master.vm.box = "hashicorp/bionic64"
    master.vm.hostname = "master.inventory-manager.com"
    master.vm.network "private_network", ip: "172.42.42.100"
    master.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "master"
      vb.memory = 2048
      vb.cpus = 2
    end
	master.vm.provision "file", source: "dashboard.yaml", destination: "dashboard.yaml"
    master.vm.provision "shell", path: "provision_master.sh"
  end

  # K8S WORKER1
  config.vm.define "worker1" do |worker1|
    worker1.vm.box = "hashicorp/bionic64"
    worker1.vm.hostname = "worker1.inventory-manager.com"
    worker1.vm.network "private_network", ip: "172.42.42.101"
    worker1.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "worker1"
      vb.memory = 1024
      vb.cpus = 1
    end
    worker1.vm.provision "shell", path: "provision_worker.sh"
  end

  # K8S WORKER2
  config.vm.define "worker2" do |worker2|
    worker2.vm.box = "hashicorp/bionic64"
    worker2.vm.hostname = "worker2.inventory-manager.com"
    worker2.vm.network "private_network", ip: "172.42.42.102"
    worker2.vm.provider "virtualbox" do |vb|
      vb.gui = false
      vb.name = "worker2"
      vb.memory = 1024
      vb.cpus = 1
    end
    worker2.vm.provision "shell", path: "provision_worker.sh"
  end

  # FOLDER SETTINGS
  # master.vm.synced_folder "../data", "/vagrant_data"

end
