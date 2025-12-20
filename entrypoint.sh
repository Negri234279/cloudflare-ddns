#!/bin/bash
set -e

INTERVAL=${CF_INTERVAL:-300}
STATE_DIR=${STATE_DIR:-/data}

timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

ARCH=$(uname -m)
VERSION=${APP_VERSION:-unknown}

echo "$(timestamp) 🚀 Cloudflare DDNS version $VERSION running on $ARCH (TZ=$TZ)"
echo "$(timestamp) ⏱️ Interval: ${INTERVAL}s"

# ⚠️ Check if /data is a real mounted volume
if mountpoint -q "$STATE_DIR"; then
  echo "$(timestamp) ✅ Persistence enabled: $STATE_DIR is a mounted volume"
else
  echo "$(timestamp) ⚠️ WARNING: $STATE_DIR is not a mounted volume. State will not persist after container restart."
fi

echo

while true; do
  /app/update-dns.sh
  sleep "$INTERVAL"
done
