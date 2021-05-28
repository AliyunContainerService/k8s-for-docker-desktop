#!/bin/bash

set -e
KUBE_DASHBOARD_VERSION=v2.0.3
METRICS_SCRAPER=v1.0.4
KUBENETESUI_URL=kubernetesui
ALIYUN_KUBENETESUI_URL=registry.cn-hangzhou.aliyuncs.com/kubernetes_ns

# get images (ui)
imagesui=(dashboard:${KUBE_DASHBOARD_VERSION}
    metrics-scraper:${METRICS_SCRAPER})

for imageName in ${imagesui[@]} ; do
    docker pull $ALIYUN_KUBENETESUI_URL/$imageName
    docker tag $ALIYUN_KUBENETESUI_URL/$imageName $KUBENETESUI_URL/$imageName
    docker rmi $ALIYUN_KUBENETESUI_URL/$imageName
done

# show images
docker images