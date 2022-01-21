# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANT_API_VERSION = "2"

ip_mask = "10.0.0.%02d"
ip_octet4 = 10
worker_cnt = 2

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "generic/centos8"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL

  config.ssh.insert_key = false
  config.ssh.forward_agent = true

  config.vm.define "master" do |master|
    master.vm.hostname = "node-master"
    master.vm.network "private_network", ip: "#{ip_mask}" % ip_octet4

    master.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end

    master.vm.provision "shell", inline: <<-SHELL
      yum install -y sshpass
      sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/#g' /etc/ssh/sshd_config
      systemctl restart sshd
    SHELL

    # kubeadm
    master.vm.provision "file", source: "kubeadm-config.yaml", destination: "$HOME/kubernetes/init.yaml"
  end

  (1..worker_cnt).each do |worker_id|
    config.vm.define "worker-#{worker_id}" do |worker|
      ip_octet4 = ip_octet4 + 1
      worker.vm.hostname = "node-worker#{worker_id}"
      worker.vm.network "private_network", ip: "#{ip_mask}" % ip_octet4

      worker.vm.provider "libvirt" do |libvirt|
        libvirt.memory = 2048
        libvirt.cpus = 1
      end

      worker.vm.provision "shell", inline: <<-SHELL
        yum install -y sshpass
        sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/#g' /etc/ssh/sshd_config
        systemctl restart sshd
      SHELL
    end
  end

  config.vm.define "conf" do |conf|
    conf.vm.hostname = "node-conf"
    conf.vm.network "private_network", ip: "#{ip_mask}" % '99'

    conf.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 1024
      libvirt.cpus = 1
    end

    conf.vm.provision "shell", inline: <<-SHELL
      yum install -y ansible
    SHELL

    # node.vm.synced_folder "ansible/", "/vagrant", type: "virtiofs"
    conf.vm.provision "file", source: "ansible/", destination: "$HOME/ansible"
    conf.vm.provision "file", source: "scripts/ansible/install_req.sh", destination: "$HOME/bin/ansible_req"

    # node.vm.provision "ansible", type: 'ansible' do |ansible|
    #   ansible.playbook = "playbook.yml"
    #   ansible.config_file = "ansible.cfg"
    #   ansible.inventory_path = "hosts"
    #   ansible.galaxy_role_file = "requirements.yml"
    # end
  end
end
