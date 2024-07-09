#!/bin/sh

OUTPUT_DIR=../output
INIT_FILE=$OUTPUT_DIR/vault_init.output
VAULT_URL=https://127.0.0.1:8200

if [ -z $1 ]; then
      SECRET_ENGINE=dev
else
      SECRET_ENGINE=$1
fi

echo "------------------------------------"
echo "Vault secret engine: ${SECRET_ENGINE}"

echo "------------------------------------"
echo "Initializing Vault ...."
if [ -f $INIT_FILE ]; then
   echo "File $INIT_FILE already exists. Vault seems to be already initialized"
else
    echo "Initializing Vault"
    curl \
	    --request PUT \
	    --data '{"secret_shares": 1,"secret_threshold": 1}' \
	    $VAULT_URL/v1/sys/init > $INIT_FILE
fi

# cat $INIT_FILE | grep -o '"[^"]*"\s*:\s*"[^"]*"' | grep root_token | \
#     sed 's/"root_token"://' |  tr -d '\n' | sed  's:"::g' > $OUTPUT_DIR/vault_root_token

# cat $INIT_FILE | grep -o '"[^"]*"\s*:\s*[^,]*"' | grep \"keys\" | \
#     tr -d '\n' | sed 's/"keys":\["//' |  sed 's/"//' > $OUTPUT_DIR/vault_master_key

echo "------------------------------------"
echo "Unsealing Vault ...."
master_key=$(cat $OUTPUT_DIR/vault_master_key)
echo "Master Key:"
echo $master_key
data='{"key": "'
data+=$master_key
data+='"}'
echo $data
curl --request PUT --data "$data" $VAULT_URL/v1/sys/unseal

echo "------------------------------------"
echo "Crating default secrets engine ...."
root_token=$(cat $OUTPUT_DIR/vault_root_token)
echo "Root token:"
echo $root_token
curl \
    --header "X-Vault-Token: $root_token" \
    --request POST \
    --data '{"type": "kv", "options":{"version":"2"}}' \
    $VAULT_URL/v1/sys/mounts/$SECRET_ENGINE

echo "------------------------------------"
echo "Importing infrastructure secrets...."
# Kubernetes
# client key
key=$(cat ../output/client_key | sed ':a;N;$!ba;s/\n/\\n/g')
data='{"data": {"client_key": "'
data+=$key
# client certificate
key=$(cat ../output/client_certificate | sed ':a;N;$!ba;s/\n/\\n/g')
data+='","client_certificate": "'
data+=$key
# ca certificate
key=$(cat ../output/ca_certificate | sed ':a;N;$!ba;s/\n/\\n/g')
data+='","ca_certificate": "'
data+=$key

data+='"}}'

echo $data | awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' > tmp.key
cat tmp.key
curl --header "X-Vault-Token: $root_token" \
      --request POST \
      --data @tmp.key \
      $VAULT_URL/v1/$SECRET_ENGINE/data/kubernetes
rm tmp.key

# Container Registry
registry_username=$(cat ../output/registry_username)
registry_password=$(cat ../output/registry_password)
data='{"data": {"username": "'
data+=$registry_username
data+='","password": "'
data+=$registry_password
data+='"}}'
curl --header "X-Vault-Token: $root_token" \
      --request POST \
      --data "$data" \
      $VAULT_URL/v1/$SECRET_ENGINE/data/container_registry
	  
# Nexus
nexus_username=$(cat ../output/nexus_username)
nexus_password=$(cat ../output/nexus_password)
data='{"data": {"username": "'
data+=$nexus_username
data+='","password": "'
data+=$nexus_password
data+='"}}'
curl --header "X-Vault-Token: $root_token" \
      --request POST \
      --data "$data" \
      $VAULT_URL/v1/$SECRET_ENGINE/data/nexus

# Keycloak - Admin Credentials
keycloak_username=$(cat ../output/keycloak_username)
keycloak_password=$(cat ../output/keycloak_password)
data='{"data": {"username": "'
data+=$keycloak_username
data+='","password": "'
data+=$keycloak_password
data+='"}}'
curl --header "X-Vault-Token: $root_token" \
      --request POST \
      --data "$data" \
      $VAULT_URL/v1/$SECRET_ENGINE/data/keycloak

# Keycloak - App technical user
keycloak_app_username=$(cat ../output/keycloak_app_username)
keycloak_app_password=$(cat ../output/keycloak_app_password)
data='{"data": {"username": "'
data+=$keycloak_app_username
data+='","password": "'
data+=$keycloak_app_password
data+='"}}'
curl --header "X-Vault-Token: $root_token" \
      --request POST \
      --data "$data" \
      $VAULT_URL/v1/$SECRET_ENGINE/data/app/keycloak_technical_user


# Github
git_username=$(cat ../output/git_username)
git_access_token=$(cat ../output/git_access_token)
data='{"data": {"username": "'
data+=$git_username
data+='","access_token": "'
data+=$git_access_token
data+='"}}'
curl --header "X-Vault-Token: $root_token" \
      --request POST \
      --data "$data" \
      $VAULT_URL/v1/$SECRET_ENGINE/data/github