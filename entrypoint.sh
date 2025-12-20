#!/bin/bash
set -e

INTERVAL=${CF_INTERVAL:-300}

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

ARCH=$(uname -m)
VERSION=${APP_VERSION:-unknown}

echo "$(timestamp) 🚀 Cloudflare DDNS version $VERSION running on $ARCH (TZ=$TZ)"
echo "$(timestamp) ⏱️ Interval: ${INTERVAL}s"
echo

while true; do
  /app/update-dns.sh
  sleep "$INTERVAL"
done
