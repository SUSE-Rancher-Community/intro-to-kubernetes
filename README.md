# Introduction to Kubernetes

![K8s Logo](Kubernetes_Logo.png)

This repository contains the source code for creating a local Kubernetes cluster setup using either [K3d](https://k3d.io/v4.4.8/) or [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/). It also contains a set of manifest files to deploy a basic application to your local K8s cluster.

## Slide Deck
The slide deck for the `Introduction to Kubernetes` course can be found in the *slide-deck* folder.

## Create Local Kubernetes Cluster with K3d
k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker. 

![K3d Logo](k3d-logo.png)

## Requirements/Prerequisites
- [Docker](https://docs.docker.com/engine/install/)
- [Install K3d](https://k3d.io/v4.4.8/#installation)

## Provision Cluster with K3d
The first step is to ensure that the docker engine is running on your machine.
```
k3d cluster create example-cluster --servers 3 --agents 2
```

## Delete Cluster with K3d
You can delete a cluster with the following command:
```
k3d cluster delete example-cluster
```

## Create Local Kubernetes Cluster with RKE
RKE is a CNCF-certified Kubernetes distribution that runs entirely within Docker containers.

![RKE Logo](rke.png)

## Requirements/Prerequisites
- [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/installation/)
- [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/docs/installation)

## Create Virtual Machines (VMs)
To spin up the virtual machines, run the following command at the root level of the project directory:
```
vagrant up
```
Once the VMs are up and running, you can check their status with `vagrant status` or by connecting to anyone of them using `vagrant ssh [hostname]`. Once you've confirmed that all machines are running with no issues, copy over the generated SSH keys from your workstation/host to each guest machine with the following commands:
```
ssh-copy-id root@[relevant ip address]
```
When prompted, enter the root user password configured in the bootstrap node script.

## Provision/Create Kubernetes Cluster with RKE
To provision the cluster on the VMs, run the `rke config` command. You will be presented with a series of questions to which the answers will be used to declare the cluster config in a generated `cluster.yml` file upon completion. Alternatively, you can create the cluster.yml file and populate it with your desired configuration. Once you have the `cluster.yml` file, run the following command:
```
rke up
```
When the cluster has been provisioned, the following files will be generated in the root directory:
- cluster.rkestate - the cluster state file 
- kube_config_cluster.yml - kube config file

To add the cluster to your context, copy the kube config file:
```
cp kube_config_cluster.yml ~/.kube/config
```
If you do not have a `./kube` directory on your machine you will have to create one. 

The last step will be to check that you can connect to your cluster:
```
kubectl cluster-info
```
or
```
kubectl config current-context
```

## Manifests
The Kubernetes resources can be found inside the *manifests* folder.