# ------------------------------------------------------------
# Base
# ------------------------------------------------------------
FROM node:22-slim AS base

# ---------- Build arguments ----------
ARG VERSION="1.0.0"
ARG VCS_REF="unknown"
ARG BUILD_DATE="unknown"

LABEL \
    org.opencontainers.image.title="cloudflare-ddns" \
    org.opencontainers.image.description="Cloudflare Dynamic DNS updater" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.created="${BUILD_DATE}"

ENV TZ="Europe/Madrid"
ENV STATE_DIR="/data"
ENV CF_TTL="1"
ENV CF_PROXIED="false"
ENV CF_INTERVAL="300"
ENV CF_RECORD_TYPE="A"
ENV APP_VERSION=${VERSION}

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd -r ddns && useradd -r -g ddns ddns \
    && mkdir -p /app /data \
    && chown -R ddns:ddns /app /data

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
COPY package*.json ./

# ------------------------------------------------------------
# Development
# ------------------------------------------------------------
FROM base AS dev

ENV NODE_ENV="development"

RUN npm install

COPY src ./src

RUN chmod +x /entrypoint.sh \
    && chown -R ddns:ddns /app

USER ddns

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "run", "start:dev"]

# ------------------------------------------------------------
# Production
# ------------------------------------------------------------
FROM base AS prod

ENV NODE_ENV="production"

RUN npm ci --omit=dev

COPY src ./src

RUN chmod +x /entrypoint.sh \
    && chown -R ddns:ddns /app

USER ddns

ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "run", "start:prod"]
