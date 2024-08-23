#!/bin/bash
# usage : bash ./purge_cloudflare all

zone_id=""
auth_mail=""
auth_key=""

case $1 in
  preprod)
    echo "Purge du cache CF en preprod"
    curl --request POST \
      --url https://api.cloudflare.com/client/v4/zones/${zone_id}/purge_cache \
      --header "Content-Type: application/json" \
      --header "X-Auth-Email: $auth_mail" \
      --header "X-Auth-Key: $auth_key" \
      --data '{
      "hosts": ["preprod.host.com"]
    }'
    ;;
  prod)
    echo "Purge du cache CF en prod"
    curl --request POST \
      --url https://api.cloudflare.com/client/v4/zones/${zone_id}/purge_cache \
      --header "Content-Type: application/json" \
      --header "X-Auth-Email: $auth_mail" \
      --header "X-Auth-Key: $auth_key" \
      --data '{
      "hosts": ["prod.host.com"]
    }'
    ;;
  all)
    echo "Purge du cache CF"
    curl --request POST \
      --url https://api.cloudflare.com/client/v4/zones/${zone_id}/purge_cache \
      --header "Content-Type: application/json" \
      --header "X-Auth-Email: $auth_mail" \
      --header "X-Auth-Key: $auth_key" \
      --data '{
      "purge_everything": true
    }'
    ;;
  *)
    echo "Option invalide"
    ;;
esac

