#!/bin/bash
set -e

if [ "$(id -u)" = "0" ]; then
    echo "🔧 Ensuring /data permissions"
    chown -R ddns:ddns /data || true
    exec gosu ddns "$@"
else
    exec "$@"
fi
