FROM node:22

# ---------- Build arguments ----------
ARG VERSION="1.0.0"
ARG VCS_REF="unknown"
ARG BUILD_DATE="unknown"

LABEL \
    org.opencontainers.image.title="cloudflare-ddns" \
    org.opencontainers.image.description="Cloudflare Dynamic DNS updater" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.source="https://github.com/Negri234279/cloudflare-ddns" \
    org.opencontainers.image.url="https://github.com/Negri234279/cloudflare-ddns" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.authors="Negrii"

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    bash \
    jq \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r ddns && useradd -r -g ddns ddns \
    && mkdir -p /app /data \
    && chown -R ddns:ddns /app /data

WORKDIR /app

COPY package*.json src ./
COPY entrypoint.sh /entrypoint.sh

RUN npm install
RUN chown -R ddns:ddns /app && chmod +x /entrypoint.sh

ENV TZ="Europe/Madrid"
ENV CF_TTL=1
ENV CF_PROXIED=false
ENV CF_INTERVAL=300
ENV CF_RECORD_TYPE="A"
ENV APP_VERSION=${VERSION}
ENV STATE_DIR=/data

USER ddns

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "run", "start:prod"]
