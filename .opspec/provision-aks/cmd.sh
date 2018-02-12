#!/usr/bin/env sh

echo "*******************************"
echo "** provisioning common infra **"
echo "*******************************"

# this is necessary to dynamically name the common infra specific to a subscription
echo "setting common infra names to use first 8 characters of subscriptionId"
subIdNoDash="$(echo ${subscriptionId} | sed 's/[-].*//')"

echo "generating resource group name"
resourceGroupName="ncp${subIdNoDash}-common-infra"
echo "resourceGroupName=$resourceGroupName"

echo "generating key vault service name"
keyVaultName="ncp${subIdNoDash}infkvtwus01"
echo "keyVaultName=$keyVaultName"

echo "generating service principal name"
servicePrincipalName="ncp-${subIdNoDash}-infra-sp"
echo "servicePrincipalName=$servicePrincipalName"