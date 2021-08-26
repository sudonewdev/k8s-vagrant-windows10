# image name to be used  as the base image for the hosts
IMAGE_NAME = "bento/ubuntu-20.04"
# subnet to be used for the nodes
SUBNET = "172.16.16."
# pod cidr to be used with kubeadm
POD_CIDR = "192.168.0.0/16"
# number of workers to be deployed
NodeCount = 2

Vagrant.configure("2") do |config|
    config.ssh.insert_key = false
    config.vm.box_check_update = false
    config.vm.provision "shell", path: "scripts/bootstrap.sh"

    config.vm.define "master" do |master|
        master.vm.box = IMAGE_NAME
        master.vm.network "private_network", ip: SUBNET + "#{10}"
        master.vm.hostname = "master.jlab.org"
        #master.vm.box_version = "202107.28.0"
		master.vm.synced_folder "data/", "/vagrant_data"
        master.vm.provider "virtualbox" do |v|
            v.name = "master"
            v.memory = 4096
            v.cpus = 2
        end
        master.vm.provision "shell", path: "scripts/master-pre-req.sh" do |s|
		  s.args = [POD_CIDR, SUBNET + "#{10}"]
        end
    end

    (1..NodeCount).each do |i|
        config.vm.define "worker-#{i}" do |node|
            node.vm.box = IMAGE_NAME
            node.vm.network "private_network", ip: SUBNET + "#{i + 10}"
            node.vm.hostname = "worker-#{i}.jlabs.org"
            #node.vm.box_version = "202107.28.0"
			node.vm.synced_folder "data/", "/vagrant_data"
            node.vm.provider "virtualbox" do |v|
                v.name = "worker-#{i}"
                v.memory = 4096
                v.cpus = 2
            end
			node.vm.provision "shell", path: "scripts/worker-pre-req.sh"
        end
    end
end