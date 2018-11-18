# 为中国用户在 Docker for Mac/Windows 中开启 Kubernetes 

中文|[English](README_en.md)

说明: 

* 当前 master 分支已经在 Docker for Mac/Windows 18.09/18.06 (包含 Kubernetes 1.10.3) 版本测试通过，如果你希望使用 18.03 版本, 请使用下面命令切换 18.03 分支 ```git checkout 18.03```

### 为 Docker for Mac 开启 Kubernetes

为 Docker daemon 配置 Docker Hub 的中国官方镜像加速 ```https://registry.docker-cn.com```

![mirror](images/mirror.png)

可选操作: 为 Kubernetes 配置 CPU 和 内存资源，建议分配 4GB 或更多内存。 

![resource](images/resource.png)

预先从阿里云Docker镜像服务下载 Kubernetes 所需要的镜像, 可以通过修改 ```images.properties``` 文件加载你自己需要的镜像


```
./load_images.sh
```

开启 Kubernetes，并等待 Kubernetes 开始运行


![k8s](images/k8s.png)


### Enable Kubernetes on Docker for Windows

为 Docker daemon 配置 Docker Hub 的中国官方镜像加速 ```https://registry.docker-cn.com```

![mirror](images/mirror_win.png)

可选操作: 为 Kubernetes 配置 CPU 和 内存资源，建议分配 4GB 或更多内存。 

![resource](images/resource_win.png)

预先从阿里云Docker镜像服务下载 Kubernetes 所需要的镜像, 可以通过修改 ```images.properties``` 文件加载你自己需要的镜像

使用 Bash shell

```
./load_images.sh
```

使用 PowerShell

```
 .\load_images.ps1
```

说明: 如果因为安全策略无法执行 PowerShell 脚本，请在 “以管理员身份运行” 的 PowerShell 中执行 ```Set-ExecutionPolicy RemoteSigned``` 命令。 

开启 Kubernetes，并等待 Kubernetes 开始运行

![k8s](images/k8s_win.png)


### 配置 Kubernetes


可选操作: 切换Kubernetes运行上下文至 docker-for-desktop


```
kubectl config use-context docker-for-desktop
```

验证 Kubernetes 集群状态

```
kubectl cluster-info
kubectl get nodes
```

部署 Kubernetes dashboard

```
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
```

或

```
kubectl create -f kubernetes-dashboard.yaml
```

开启 API Server 访问代理

```
kubectl proxy
```

通过如下 URL 访问 Kubernetes dashboard

http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/overview?namespace=default

### 安装 Helm

可以根据文档安装 helm https://github.com/helm/helm/blob/master/docs/install.md

```
# Use homebrew on Mac
brew install kubernetes-helm

# Install Tiller into your Kubernetes cluster
helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0

# update charts repo
helm repo update
```

### 安装 Istio

可以根据文档安装 Istio https://istio.io/docs/setup/kubernetes/

下载 Istio 1.0.3 并安装 CLI

```
curl -L https://git.io/getLatestIstio | sh -
cd istio-1.0.3/
export PATH=$PWD/bin:$PATH
```

通过 Helm chart 安装 Istio

```
helm install install/kubernetes/helm/istio --name istio --namespace istio-system
```

查看 istio 发布状态

```
helm status istio
```

为 ```default``` 名空间开启自动 sidecar 注入

```
kubectl label namespace default istio-injection=enabled
kubectl get namespace -L istio-injection
```

安装 Book Info 示例

```
kubectl apply -f samples/bookinfo/platform/kube/bookinfo.yaml
kubectl apply -f samples/bookinfo/networking/bookinfo-gateway.yaml
```


确认示例应用在运行中

```
export GATEWAY_URL=localhost:80
curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage
```

卸载 Istio

```
helm del --purge istio
kubectl delete -f install/kubernetes/helm/istio/templates/crds.yaml -n istio-system
```


