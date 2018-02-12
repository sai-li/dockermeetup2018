#!/usr/bin/env sh

echo "generating cert name"
certName="${environment}-cert"
certKeyName="${environment}-key"

### begin login
loginCmd='az login -u "$loginId" -p "$loginSecret"'

# handle opts
if [ "$loginTenantId" != " " ]; then
    loginCmd=$(printf "%s --tenant %s" "$loginCmd" "$loginTenantId")
fi

case "$loginType" in
    "user")
        echo "logging in as user"
        ;;
    "sp")
        echo "logging in as service principal"
        loginCmd=$(printf "%s --service-principal" "$loginCmd")
        ;;
esac
eval "$loginCmd" >/dev/null

echo "setting default subscription"
az account set --subscription "$subscriptionId"
### end login

### begin create/retrieve
echo "checking for existing ssh cert"
if [ "$(az keyvault secret show --name "$certName" --vault-name "$vaultName")" != "" ]
then
  echo "found existing ssh cert" 

  # returns file of public cert
  commonCertPub="$(az keyvault secret show \
      --output json \
      --name "$certName" \
      --vault-name "$vaultName")"

  echo "${commonCertPub}" | jq --raw-output '.value' | base64 -d > /id_aks.pub

  # returns file of private key
  commonCertKey="$(az keyvault secret show \
      --output json \
      --name "$certKeyName" \
      --vault-name "$vaultName")"
      
  echo "${commonCertKey}" | jq --raw-output '.value' | base64 -d > /id_aks

else
  echo "creating ssh cert and key"
  ssh-keygen -t rsa -b 2048 -f /commonCert -N ''
  cat commonCert.pub > /id_aks.pub
  cat commonCert > /id_aks

  echo "adding ssh cert and key to keyvault secrets"
  az keyvault secret set \
    --name "$certName" \
    --vault-name "$vaultName" \
    --encoding "base64" \
    --file "/id_aks.pub"

  az keyvault secret set \
    --name "$certKeyName" \
    --vault-name "$vaultName" \
    --encoding "base64" \
    --file "/id_aks"
fi

### end create/retrieve