#!/bin/bash
set -e

INTERVAL=${CF_INTERVAL:-300}

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

ARCH=$(uname -m)

echo "$(timestamp) 🚀 Cloudflare DDNS running on $ARCH (TZ=$TZ)"
echo "$(timestamp) ⏱️ Interval: ${INTERVAL}s"

while true; do
  /app/update-dns.sh
  sleep "$INTERVAL"
done
