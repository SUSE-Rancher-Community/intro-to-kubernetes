# Introduction to Kubernetes

![K8s Logo](Kubernetes_Logo.png)

This repository contains the source code for creating a local Kubernetes cluster setup using either [K3d](https://k3d.io/v4.4.8/) or [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/). It also contains a set of manifest files to deploy a basic application to your local K8s cluster.

## Slide Deck

The slide deck for the `Introduction to Kubernetes` course can be found in the *slide-deck* folder.

## Install Rancher Desktop

[Rancher Desktop](https://github.com/rancher-sandbox/rancher-desktop/releases), download the latest version of _Rancher Desktop_for your desktop operating system.

## Install `kubectl`

This link for [kubectl](https://kubernetes.io/docs/tasks/tools/) will cover the full installation of `kubectl`. Download and install `kubectl` for your desktop operating system.

## Create Local Kubernetes Cluster with K3d

k3d is a lightweight wrapper to run k3s (Rancher Lab’s minimal Kubernetes distribution) in docker.

![K3d Logo](k3d-logo.png)

### K3d Requirements/Prerequisites

- [Docker](https://docs.docker.com/engine/install/)
- [Install K3d](https://k3d.io/v4.4.8/#installation)

### Provision Cluster with K3d

The first step is to ensure that the docker engine is running on your machine. Once you've verified that, you can proceed to create a cluster with the following command:

``` bash
k3d cluster create example-cluster --servers 3 --agents 2
```

### Delete Cluster with K3d

You can delete a cluster with the following command:

``` bash
k3d cluster delete example-cluster
```

## Create Local Kubernetes Cluster with RKE

RKE is a CNCF-certified Kubernetes distribution that runs entirely within Docker containers.

![RKE Logo](rke.png)

### RKE Requirements/Prerequisites

- [Rancher Kubernetes Engine (RKE)](https://rancher.com/docs/rke/latest/en/installation/)
- [Virtual Box](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/docs/installation)

### Create Virtual Machines (VMs)

To spin up the virtual machines, run the following command at the root level of the project directory:

``` bash
vagrant up
```

Once the VMs are up and running, you can check their status with `vagrant status` or by connecting to anyone of them using `vagrant ssh [hostname]`. Once you've confirmed that all machines are running with no issues, copy over the generated SSH keys from your workstation/host to each guest machine with the following commands:

``` bash
ssh-copy-id root@[relevant ip address]
```

When prompted, enter the root user password configured in the bootstrap node script.

### Provision/Create Kubernetes Cluster with RKE

To provision the cluster on the VMs, run the `rke config` command. You will be presented with a series of questions to which the answers will be used to declare the cluster config in a generated `cluster.yml` file upon completion. Alternatively, you can create the cluster.yml file and populate it with your desired configuration. Once you have the `cluster.yml` file, run the following command:

``` bash
rke up
```

When the cluster has been provisioned, the following files will be generated in the root directory:

- cluster.rkestate - the cluster state file 
- kube_config_cluster.yml - kube config file

To add the cluster to your context, copy the kube config file:

``` bash
cp kube_config_cluster.yml ~/.kube/config
```

If you do not have a `./kube` directory on your machine you will have to create one.

The last step will be to check that you can connect to your cluster:

``` bash
kubectl cluster-info
```

or

``` bash
kubectl config current-context
```

## `kubectl` Exercises

No matter what cluster you are using `k3s`, `k3d`, `RKE` or even `Rancher Desktop`, you should be able to leverage the _manifests_ located in the *manifests* folder. These are good to test out the `kubectl` and one of the aforementioned Kubernetes clusters.

### Check your `kubectl` context

This command will let you know what of the many clusters your `kubectl` is pointed to:

``` bash
kubectl config view
```

You should see something similar to this in the response:

``` bash
current-context: rancher-desktop
```

### Create a Pod

In your terminal change directories to the *manifests* folder in this GitHub repository.

Once you are in this directory you can run the following command to create a pod:

```bash
kubectl apply -f pod.yaml 
```

And you should see something like this as a response:

```bash
pod/express-test created
```

### Describe a Pod

The `describe` command will give you the details on a particular object in the cluster. We are going to describe the pod that we just created:

```bash
kubectl describe pod express-test
```

The responses should look like something below (might not be exact):

```bash
Name:         express-test
Namespace:    default
Priority:     0
Node:         lima-rancher-desktop/192.168.5.15
Start Time:   Mon, 25 Oct 2021 08:40:45 -0400
Labels:       app=express-test
Annotations:  <none>
Status:       Running
IP:           10.42.0.36
IPs:
  IP:  10.42.0.36
Containers:
  express-test:
    Container ID:   containerd://f6d08505d3509140d575ff0e76762f622d26e8c3cc1d54b20713eb49ba91b3e2
    Image:          lukondefmwila/express-test:latest
    Image ID:       docker.io/lukondefmwila/express-test@sha256:c53f609cb6daadc3e161745c969b7446694205925fe2ce33f461b5c980cbd8ef
    Port:           8080/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 25 Oct 2021 08:40:54 -0400
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-2kwb2 (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  default-token-2kwb2:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-2kwb2
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                 node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  8m12s  default-scheduler  Successfully assigned default/express-test to lima-rancher-desktop
  Normal  Pulling    8m12s  kubelet            Pulling image "lukondefmwila/express-test:latest"
  Normal  Pulled     8m3s   kubelet            Successfully pulled image "lukondefmwila/express-test:latest" in 8.463684s
  Normal  Created    8m3s   kubelet            Created container express-test
  Normal  Started    8m3s   kubelet            Started container express-test
```

### Delete a Pod

The `delete` command can delete an object from your cluster. In this we will delete the pod we just created:

```bash
kubectl delete pod express-test
```

The output should look something like this:

```bash
pod "express-test" deleted
```

