#!/bin/bash
set -e

STATE_FILE="/tmp/last_ip"

: "${CF_TTL:=300}"
: "${CF_PROXIED:=false}"

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

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

echo "$(timestamp) 🔄 IP changed: $LAST_IP → $IP"

RESPONSE=$(curl -s -X PATCH \
  "https://api.cloudflare.com/client/v4/zones/$CF_ZONE_ID/dns_records/$CF_DNS_RECORD_ID" \
  -H "Authorization: Bearer $CF_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
        \"type\": \"A\",
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
