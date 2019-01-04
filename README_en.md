# Enable Kubernetes on Docker for Mac/Windows in China

[中文](README.md)|English

NOTE: 

* The master branch is tested with Docker for Mac/Windows 18.09/18.06 (with Kubernetes 1.10.3). If you want to use 18.03, please use the 18.03 branch ```git checkout 18.03```

### Enable Kubernetes on Docker for Mac

Config registry mirror for Docker daemon with ```https://registry.docker-cn.com```

![mirror](images/mirror.png)

Optional: config the CPU and memory for Kubernetes, 4GB RAM or more is suggested. 

![resource](images/resource.png)

Preload Kubernetes images form Alibaba Cloud Registry Service, NOTE: you can modify the ```images.properties``` for your own images


```bash
./load_images.sh
```

Enable Kubernetes in Docker for Mac, and wait a while for Kubernetes is running


![k8s](images/k8s.png)


### Enable Kubernetes on Docker for Windows

Config registry mirror for Docker daemon with ```https://registry.docker-cn.com```

![mirror](images/mirror_win.png)

Optional: config the CPU and memory for Kubernetes, 4GB RAM or more is suggested. 

![resource](images/resource_win.png)

Preload Kubernetes images form Alibaba Cloud Registry Service, NOTE: you can modify the ```images.properties``` for your own images

In Bash shell

```bash
./load_images.sh
```

or in PowerShell of Windows

```powershell
 .\load_images.ps1
```

NOTE: if you failed to start PowerShell scripts for security policy, please execute ```Set-ExecutionPolicy RemoteSigned``` command in PowerShell with "Run as administrator" option. 

Enable Kubernetes in Docker for Windows, and wait a while for Kubernetes is running

![k8s](images/k8s_win.png)


### Config Kubernetes


Optional: switch the context to docker-for-desktop


```shell
kubectl config use-context docker-for-desktop
```

Verify Kubernetes installation

```shell
kubectl cluster-info
kubectl get nodes
```

Deploy Kubernetes dashboard

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
```

or

```shell
kubectl create -f kubernetes-dashboard.yaml
```

Start proxy for API server

```shell
kubectl proxy
```

Access Kubernetes dashboard

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default

#### Config kubeconfig (Or skip)

For Mac

```bash
$ TOKEN=$(kubectl -n kube-system describe secret default| awk '$1=="token:"{print $2}')
kubectl config set-credentials docker-for-desktop --token="${TOKEN}"
```

For Windows

```cmd
$TOKEN=((kubectl -n kube-system describe secret default | Select-String "token:") -split " +")[1]
kubectl config set-credentials docker-for-desktop --token="${TOKEN}"
```

#### Choose kubeconfig file (Optional)

![resource](images/k8s_credentials.png)

Choose kubeconfig file, Path：

```
Win: %UserProfile%\.kube\config
Mac: $HOME/.kube/config
```

Click login, go to Kubernetes Dashboard

### Install Helm

Install helm following the instruction on https://github.com/helm/helm/blob/master/docs/install.md

#### For Mac OS

```shell
# Use homebrew on Mac
brew install kubernetes-helm

# Install Tiller into your Kubernetes cluster
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0 --skip-refresh

# update charts repo (Optional)
helm repo update
```

#### For Windows

```shell
# Use Chocolatey on Windows
# NOTE: please ensure you can access googleapis
choco install kubernetes-helm

# Install Tiller into your Kubernetes cluster
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0 --skip-refresh

# update charts repo (Optional)
helm repo update
```

### Install Istio

More details can be found in https://istio.io/docs/setup/kubernetes/

Download Istio 1.0.4 and install CLI

```bash
curl -L https://git.io/getLatestIstio | sh -
cd istio-1.0.4/
export PATH=$PWD/bin:$PATH
```

Install Istio with Helm chart

```shell
helm install install/kubernetes/helm/istio --name istio --namespace istio-system
```

Check status of istio release

```shell
helm status istio
```

Enable automatic sidecar injection for ```default``` namespace

```shell
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection
```

Install Book Info sample

```shell
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml


Confirm application is running

```bash
export GATEWAY_URL=localhost:80
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage
```

Delete Istio

```shell
helm del --purge istio
kubectl delete -f install/kubernetes/helm/istio/templates/crds.yaml -n istio-system
```


