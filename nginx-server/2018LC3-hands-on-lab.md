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

## 1. Build application
```
git clone https://github.com/andyzhangx/k8s-demo.git
cd k8s-demo/nginx-server/deployment/nginx-server-image/
sudo docker build --no-cache -t nginx-server:1.0.0 .
```

## 2. Create ACR
```
RESOURCE_GROUP_NAME=myResourceGroup001   #change here!!!
LOCATION=eastus
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
ACR_NAME=acrname01   #change here!!!
az acr create --resource-group $RESOURCE_GROUP_NAME --name $ACR_NAME --sku Basic

sudo az acr login --name $ACR_NAME
sudo docker images

ACR_SERVER=acrname01.azurecr.io   #change here!!!
sudo docker tag nginx-server:1.0.0 $ACR_SERVER/nginx-server:1.0.0
sudo docker images

sudo docker push $ACR_SERVER/nginx-server:1.0.0
az acr repository list --name $ACR_NAME --output table
az acr repository show-tags --name $ACR_NAME --repository nginx-server --output table
ACR_ID=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP_NAME --query "id" --output tsv)
echo $ACR_ID
```

## 3. Create AKS
```
az ad sp create-for-rbac --role="Contributor"
APP_ID=8dac0304-90bd-4b9d-9f94-b7d3415cxxxx   #change here!!!
ACR_ID=$(az acr show --name $ACR_NAME --resource-group $RESOURCE_GROUP_NAME --query "id" --output tsv)
echo $ACR_ID

az role assignment create --assignee $APP_ID --role Reader --scope $ACR_ID

CLUSTER_NAME=myAKSCluster001 #change here!!!
CLIENT_SECRET=206c5dc6-25d2-4ba4-9aad-caa017cfxxxx #change here!!!
az aks create --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME --node-count 1 --generate-ssh-keys --service-principal $APP_ID --client-secret $CLIENT_SECRET

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $CLUSTER_NAME
kubectl get nodes
```

## 4. Run application
```
az acr list --resource-group $RESOURCE_GROUP_NAME --query "[].{acrLoginServer:loginServer}" --output table
wget https://raw.githubusercontent.com/andyzhangx/k8s-demo/master/nginx-server/nginx-server-azurefile.yaml
vi nginx-server-azurefile.yaml
kubectl apply -f nginx-server-azurefile.yaml

kubectl get service nginx-server --watch
```

## 5. Scale application
```
az aks scale --resource-group=$RESOURCE_GROUP_NAME --name=$CLUSTER_NAME --node-count 3
kubectl get nodes

kubectl get pods
kubectl scale --replicas=5 deployment/nginx-server
```
