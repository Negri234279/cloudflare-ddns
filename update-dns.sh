#!/bin/bash
set -e

STATE_FILE="/tmp/last_ip"
STATE_DNS_ID_FILE="/tmp/dns_record_id"

: "${CF_TTL:=300}"
: "${CF_PROXIED:=false}"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Get current public IP
IP=$(curl -s --max-time 10 https://api.ipify.org)

if [[ -z "$IP" ]]; then
  echo "$(timestamp) ❌ Could not determine public IP"
  exit 1
fi

LAST_IP=""
[[ -f "$STATE_FILE" ]] && LAST_IP=$(cat "$STATE_FILE")

if [[ "$IP" == "$LAST_IP" ]]; then
  echo "$(timestamp) ℹ️ IP unchanged ($IP)"
  exit 0
fi

# Get DNS Record ID
if [[ -f "$STATE_DNS_ID_FILE" ]]; then
  CF_DNS_RECORD_ID=$(cat "$STATE_DNS_ID_FILE")
  echo "$(timestamp) 🔍 Using cached DNS Record ID for $CF_DOMAIN: $CF_DNS_RECORD_ID"
else
  echo "$(timestamp) 🔍 Fetching DNS Record ID for $CF_DOMAIN"

  RESPONSE=$(curl -s -X GET \
    "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records?name=$CF_DOMAIN" \
    -H "Authorization: Bearer $CF_API_TOKEN" \
    -H "Content-Type: application/json")

  echo "$RESPONSE" | jq

  SUCCESS=$(echo "$RESPONSE" | jq -r '.success')

  if [[ "$SUCCESS" != "true" ]]; then
    echo "$(timestamp) ❌ Cloudflare API error (DNS Record ID):"
    echo "$RESPONSE" | jq
    exit 1
  fi

  CF_DNS_RECORD_ID=$(echo "$RESPONSE" | jq -r '.result[0].id')

  if [[ -z "$CF_DNS_RECORD_ID" || "$CF_DNS_RECORD_ID" == "null" ]]; then
    echo "$(timestamp) ❌ Could not find DNS record ID for $CF_DOMAIN"
    exit 1
  fi

  echo "$(timestamp) ✅ Found DNS Record ID for $CF_DOMAIN: $CF_DNS_RECORD_ID"
  echo "$CF_DNS_RECORD_ID" > "$STATE_DNS_ID_FILE"
fi

echo "$(timestamp) 🔄 IP changed: $LAST_IP → $IP"

# Update DNS record
RESPONSE=$(curl -s -X PATCH \
  "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_DNS_RECORD_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
        \"type\": \"$CF_RECORD_TYPE\",
        \"name\": \"$CF_DOMAIN\",
        \"content\": \"$IP\",
        \"ttl\": $CF_TTL,
        \"proxied\": $CF_PROXIED
      }")

SUCCESS=$(echo "$RESPONSE" | jq -r '.success')

if [[ "$SUCCESS" != "true" ]]; then
  echo "$(timestamp) ❌ Cloudflare API error:"
  echo "$RESPONSE" | jq
  exit 1
fi

echo "$IP" > "$STATE_FILE"
echo "$(timestamp) ✅ DNS updated to $IP"
