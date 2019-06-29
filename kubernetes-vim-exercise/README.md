# Kubernetes VIM Exercise

## OpenStack Controller and Kubernetes Master

### Install Kubernetes Using Kubeadm

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/

### flannel CNI

```sh
# curl -OL https://raw.githubusercontent.com/coreos/flannel/a70459be0084506e4ec919aa1c114638878db11b/Documentation/kube-flannel.yml

# vim kube-flannel.yml

...
  net-conf.json: |
    {
      "Network": "10.1.0.0/16",
      "Backend": {
        "Type": "vxlan"
      }
    }
...

# kubectl apply -f kube-flannel.yml
```

### Create Kubernetes sa
```sh
# kubectl create sa admin-user

# kubectl describe sa admin-user
...
Tokens:              admin-user-token-k7gvl
...

# kubectl describe secret admin-user-token-k7gvl
...
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImFkbWluLXVzZXItdG9rZW4tazdndmwiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiYWRtaW4tdXNlciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImUzNWRhYTk2LTlhNzUtMTFlOS04MzZlLWEwNDgxY2EwNmViYiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDpkZWZhdWx0OmFkbWluLXVzZXIifQ.WaEOqCOYrxRhqac5EieD0dgHvRUF0HyWs5GHRCxdr7kX-9Q_RMVTyiVe7HORMUd2y6sGpy13H6X-DGVRkMxBgtx1HA3RyiaZHtiaHBY6mieTO7Wr6JfbjESTuTa5nA5j6hUo8QWZk9dsfwznGVzSddnkHK7B8n6DddU5s9txebSmCtvw8A7wuPWxuR6hNxHHrjbWAxYxJsBsmXafyKxc0bpAijClppQZ1beeWc_uYfwdPQS31JDJeFLHGhSz3OVdFTQA9THGzPROfNigASWFfnhppizhAtkW08rR2t1ZHEp9vjmUx2hpABF7zS_7ZmqHoGeHwOpN3ydcrKtr3Qf5wQ
...

# kubectl create clusterrolebinding cluster-admin --serviceaccount=default:admin-user --clusterrole=cluster-admin

```

### Install OpenStack Using DevStack

https://docs.openstack.org/devstack/latest/

> local-controller.conf

### Create Network and Create Amphora

https://docs.openstack.org/kuryr-kubernetes/stein/installation/services.html

### Install kuryr-kubernetes

https://docs.openstack.org/kuryr-kubernetes/latest/installation/manual.html

> kuryr-controller.conf

### Run kuryr-k8s-controller
```sh
kuryr-k8s-controller --config-file /etc/kuryr/kuryr.conf -d
```

## OpenStack Compute and Kubernetes Node

### Install OpenStack Using DevStack

https://docs.openstack.org/devstack/latest/

> local-compute.conf

### Install kuryr-kubernetes

https://docs.openstack.org/kuryr-kubernetes/latest/installation/manual.html

> kuryr-node.conf

### Copy Token File
```sh
scp ubuntu@10.0.1.207:/home/ubuntu/token /home/ubuntu/token
```

### Change CNI
```sh
cp kuryr-kubernetes/etc/cni/net.d/10-kuryr.conf /etc/cni/net.d
mv /etc/cni/net.d/10-flannel.conflist /etc/cni/net.d/20-flannel.conflist 
```

### Run kuryr-daemon
```sh
kuryr-daemon --config-file /etc/kuryr/kuryr.conf -d
```

### Testing Network Connectivity

https://github.com/openstack/kuryr-kubernetes/blob/master/doc/source/installation/testing_connectivity.rst

### Testing Kubernetes VIM

https://docs.openstack.org/tacker/latest/install/kubernetes_vim_installation.html

https://docs.openstack.org/tacker/latest/user/containerized_vnf_usage_guide.html

## Bug : Fail to create Kubernetes VIM

https://github.com/openstack/tacker/commit/831eae097fb9c8f87b7a2e41a09af31108c3c00e
