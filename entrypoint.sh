#!/bin/bash
set -e

INTERVAL=${CF_INTERVAL:-300}

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

ARCH=$(uname -m)
VERSION=$(grep -i 'org.opencontainers.image.version' /etc/os-release 2>/dev/null || echo "unknown")

echo "$(timestamp) 🚀 Cloudflare DDNS version $VERSION running on $ARCH (TZ=$TZ)"
echo "$(timestamp) ⏱️ Interval: ${INTERVAL}s"
echo

while true; do
  /app/update-dns.sh
  sleep "$INTERVAL"
done
