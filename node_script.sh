#!/bin/bash

# Enable ssh password authentication
echo "Enable SSH password authentication:"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "Set root password:"
echo -e "iamadmin\niamadmin" | passwd root >/dev/null 2>&1

# Commands for all K8s nodes
# Add Docker GPG key, Docker Repo, install Docker and enable services
# For openSUSE Leap 15.3 need to add kernel-default-extra for the overlay and
# br_netfilter kernel modules
# Also add chrony for time sync
# Add repo and Install packages
sudo zypper --non-interactive update
sudo zypper --non-interactive install docker kernel-default-extra chrony

# Start and enable Services
sudo systemctl enable chronyd
sudo systemctl start chronyd
sudo systemctl daemon-reload 
sudo systemctl enable docker
sudo systemctl start docker
# Set your timezone if required (optional) for example US Central time
# sudo timedatectl set-timezone America/Chicago

#Confirm that docker group has been created on system
sudo groupadd docker

# Add your current system user to the Docker group
sudo gpasswd -a $USER docker
docker --version

# Turn off swap
# The Kubernetes scheduler determines the best available node on 
# which to deploy newly created pods. If memory swapping is allowed 
# to occur on a host system, this can lead to performance and stability 
# issues within Kubernetes. 
# For this reason, Kubernetes requires that you disable swap in the host system.
# If swap is not disabled, kubelet service will not start on the masters and nodes
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# Turn off firewall
ufw disable

# Modify bridge adapter setting
# Configure sysctl.
sudo modprobe overlay
sudo modprobe br_netfilter

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Ensure that the br_netfilter module is loaded
lsmod | grep br_netfilter