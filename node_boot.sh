#!/usr/bin/env bash

#
# Fix ssh settings to allow the boxes to communication with each other
#
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service ssh restart
