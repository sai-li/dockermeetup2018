#!/usr/bin/env sh

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
echo "checking for existing service principal with this name"
if [ "$(az ad sp list --display-name "$name")" != "[]" ]
then
  echo "found existing service principal"
    
    spDetails="$(az ad sp list --display-name "$name" --output json)"
    echo "appId=$(echo "${spDetails}" | jq --raw-output '.[].appId')"

    appKeyValue="$(az keyvault secret show \
      --output json \
      --name "$name" \
      --vault-name "$vaultName")"
    echo "appKey=$(echo "${appKeyValue}" | jq --raw-output '.value')"
else
  echo "creating service principal for rbac"
   spResults="$(az ad sp create-for-rbac \
    --name "$name" \
    --role "$role" \
    --years "$years")"

  echo "appId=$(echo "${spResults}" | jq --raw-output '.appId')"
  echo "appKey=$(echo "${spResults}" | jq --raw-output '.password')"

  echo "service principal created"
fi

### end create/retrieve 