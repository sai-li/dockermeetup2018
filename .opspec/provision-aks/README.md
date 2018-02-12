# Provisioning aks clusters

[![aks|Microsoft](https://azurecomcdn.azureedge.net/mediahandler/acomblog/media/Default/blog/fd7cc81b-8f38-472b-b7b8-6c8da0057a89.png)](https://azure.microsoft.com/en-us/services/container-service/)

run the following command
`opctl run provision-aks`

the following resources get created or updated:
1. a service principal
2. keyvault
3. public cert and private key

the service principal secret and public and private key are stored in the kevault under the resource group for that subscription named `ncp<first 8 of subscription id>-common-infra`

## how to access aks after creation
1. username defaut: nintexadmin
2. navigate to the `ncp<first 8 of subscription id>-common-infra` resource group > open the keyvault > under secrets locate the `<environment>-key` secret and copy the value.
3. base64 decode the value to into the private key. 
4. save private key on your machine (ex: ~/.ssh/id_rsa_aks)
5. run `ssh nintexadmin@<environment>-kube.eastus.cloudapp.azure.com`
