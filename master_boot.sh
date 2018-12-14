#!/usr/bin/env bash

#
# This installs Ansible on the master machine.  Python2 is
# is also installed to support Ansible
#
apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible
#
# Fix ssh settings to allow the boxes to communication with each other
# via ssh
#
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service ssh restart
#
# Copy generated hosts file to make Ansible aware
# of the nodes to provision
#
cp /vagrant/hosts /etc/ansible/hosts
#
# This installs the docker role files for ansible to execute
#
tar -xvf /vagrant/ansible_src/docker.tar -C /etc/ansible/roles/
