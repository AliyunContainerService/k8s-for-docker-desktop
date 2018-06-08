# Enable Kubernetes on Docker for Desktop in China

NOTE: 

* The master branch is tested with Docker for Mac/Windows 18.05 (with Kubernetes 1.10.3). If you want to use Docker for Mac/Windows 18.03, please use the 18.03 branch ```git checkout 18.03```
* If you run on Windows, please execute following commands in Bash shell

Install Docker for Mac or Windows

Config registry mirror for Docker daemon with ```https://registry.docker-cn.com```

![mirror](./mirror.jpg)

Preload Kubernetes images form Alibaba Cloud Registry Service, NOTE: you can modify the ```images.properties``` for your own images

```
./load_images.sh
```

Enable Kubernetes in Docker for Mac, and wait a while for Kubernetes is running



![k8s](./k8s.jpg)

Optional: switch the context to docker-for-desktop

```
kubectl config use-context docker-for-desktop
```

Verify Kubernetes installation

```
kubectl cluster-info
kubectl get nodes
```

Deploy Kubernetes dashboard


```
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

or

```
kubectl create -f kubernetes-dashboard.yaml
```

Start proxy for API server

```
kubectl proxy
```

Access dashboard

```
http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default
```

