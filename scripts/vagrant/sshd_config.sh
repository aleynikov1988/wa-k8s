#!/usr/bin/bash

yum install -y sshpass
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/#g' /etc/ssh/sshd_config
systemctl restart sshd