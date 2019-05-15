## azure voting application on Azure China

```sh
kubectl apply -f https://raw.githubusercontent.com/andyzhangx/k8s-demo/master/azure-vote-mooncake/azure-vote.yaml
kubectl get service azure-vote-front --watch
```

 - clean up
```
kubectl delete -f https://raw.githubusercontent.com/andyzhangx/k8s-demo/master/azure-vote-mooncake/azure-vote.yaml
```

### Links
 - [tutorial-kubernetes-prepare-app](https://docs.azure.cn/zh-cn/aks/tutorial-kubernetes-prepare-app)
 - [Azure Voting App](https://github.com/Azure-Samples/azure-voting-app-redis)

