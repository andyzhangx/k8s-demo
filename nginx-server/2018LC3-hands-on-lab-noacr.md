# Build & Deploy a basic Kubernetes application using Azure AKS

## Preparation:
 - install docker
```
sudo apt install docker.io -y
```

 - [install azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest)
```
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |     sudo tee /etc/apt/sources.list.d/azure-cli.list
curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli
az login
```

 - install kubectl
```
az aks install-cli
```

## 1. Create AKS
```
CLUSTER_NAME=myAKSCluster001 #change here!!!
RESOURCE_GROUP_NAME=myResourceGroup001   #change here!!!
LOCATION=eastus
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
az aks create --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME --node-count 1 --generate-ssh-keys

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME
kubectl get nodes
```

## 2. Run application
```
kubectl create -f https://raw.githubusercontent.com/andyzhangx/k8s-demo/master/nginx-server/nginx-server-azurefile.yaml

kubectl get service nginx-server --watch
```

## 3. Scale application
```
az aks scale --resource-group=$RESOURCE_GROUP_NAME --name=$CLUSTER_NAME --node-count 3
kubectl get nodes

kubectl get pods
kubectl scale --replicas=5 deployment/nginx-server
```
