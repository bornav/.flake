
curl --header "X-Vault-Token: <get from BW>"   --request GET   https://hashicorp-vault.icylair.com/v1/certs/data/icylair-com-all-prod

cat tmp.key | jq -r '.data.data | to_entries[0].value' > tls.crt
cat tmp.key | jq -r '.data.data | to_entries[1].value' > tls.key