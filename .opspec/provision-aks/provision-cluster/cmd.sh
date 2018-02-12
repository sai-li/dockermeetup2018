#!/usr/bin/env sh

echo "******************************"
echo "** provisioning aks cluster **"
echo "******************************"

echo "generating resource group name"
resourceGroupName="${environment}-aks"
echo "resourceGroupName=$resourceGroupName"

echo "generating aks cluster name"
aksClusterName="${environment}-kube"
echo "aksClusterName=$aksClusterName"
