# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Node counter to track current node being defined
#
$node_num = 0
#
# hosts file name for Ansible
#
$host_file = "hosts"
#
# Check to see if previously generated hosts file exists and delete it 
# if it does.  Generate a new hosts file for Ansible.  An IP address
# will need to be inserted into the hosts file for each node defined
#
if File::exists?($host_file) then
  File.delete($host_file)
end
fh = File.new($host_file, "w+")
fh.puts("[localhost]")
fh.puts("127.0.0.1 ansible_connection=local")
fh.puts(" ")
fh.puts("[nodes]")
fh.close
#
# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
#
Vagrant.configure("2") do |config|
#
# Change the loop number below to determine how many nodes to generate
#
  (1..2).each do |i|
    config.vm.define "node#{i}" do |node|
	  ssh_host = "10#{i}" << "22"
	  web_host = "10#{i}" << "80"
	  private_ip = "192.168.56.10#{i}"
	  node.vm.box = "ubuntu/bionic64"
      node.vm.hostname = "node#{i}"
      node.vm.box_url = "ubuntu/bionic64"
	  node.vm.network :private_network, ip: private_ip
	  node.vm.network :forwarded_port, guest: 22, host: ssh_host, id: "ssh"
	  node.vm.network :forwarded_port, guest: 80, host: web_host
#
# Write node IP address to hosts file
#	  
	  fh = File.open($host_file, "a+")
	  fh.puts("#{private_ip} ansible_ssh_pass=vagrant")
	  fh.close
#
# Correct ssh issue for node
#
	  node.vm.provision :shell, path: "node_boot.sh"
	  node.vm.provider :virtualbox do |v|
	    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--name", "node#{i}"]
      end
	end
	$node_num = i
  end
  $node_num = $node_num + 1
#
# Build master node
#		
  config.vm.define "kmaster" do |kmaster|
  	ssh_host = "10#$node_num" << "22"
	web_host = "10#$node_num" << "80"
    kmaster.vm.box = "ubuntu/bionic64"
    kmaster.vm.hostname = "kmaster"
    kmaster.vm.box_url = "ubuntu/bionic64"
	kmaster.vm.network :private_network, ip: "192.168.56.10#$node_num"
	kmaster.vm.network :forwarded_port, guest: 22, host: ssh_host, id: "ssh"
	kmaster.vm.network :forwarded_port, guest: 80, host: web_host
#
# Provision master node by installing Ansible, correcting ssh settings
# and copying Ansible files into place.
#	
    kmaster.vm.provision :shell, path: "master_boot.sh"
    kmaster.vm.provider :virtualbox do |v|
	  v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2048]
      v.customize ["modifyvm", :id, "--name", "kmaster"]
    end
  end
#
# Install node 2
#  
#  config.vm.define "node2", autostart: false do |node2|
#    node2.vm.box = "ubuntu/bionic64"
#    node2.vm.hostname = "node2"
#    node2.vm.box_url = "ubuntu/bionic64"
#    node2.vm.network :private_network, ip: "192.168.56.103"
#	 node2.vm.network :forwarded_port, guest: 22, host: 10322, id: "ssh"
#	 node2.vm.network :forwarded_port, guest: 80, host: 10380
#
# Correct ssh issue
#
#	  node2.vm.provision :shell, path: "node_boot.sh"
#	  node2.vm.provider :virtualbox do |v|
#	  v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
#      v.customize ["modifyvm", :id, "--memory", 1024]
#      v.customize ["modifyvm", :id, "--name", "node2"]
#    end
#  end
end
