
## Fully Automated Kubernetes Cluster Setup, with one master and 'N' workers for VirtualBox over Windows 10

This will install:

- The Kubernetes version (currently 1.20)
- Docker as a runtime
- Calico as a CNI.

## Requirements

You have to install:
- [Vagrant](https://www.vagrantup.com/) 
- [VirtualBox](https://www.virtualbox.org/)

## How To Use It

```bash
git clone https://github.com/sudonewdev/k8s-vagrant-windows10
```

```bash
cd k8s-vagrant-windows10
```

```bash
vagrant up
```
```bash
vagrant ssh master-1
```
After this stage you can use kubectl

```
➜  k8s-vagrant-windows10 git:(main) ✗ kubectl get nodes
NAME       STATUS   ROLES                  AGE   VERSION
master     Ready    control-plane,master   65m   v1.20.0
worker-1   Ready    <none>                 62m   v1.20.0
worker-2   Ready    <none>                 59m   v1.20.0
```


