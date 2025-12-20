FROM alpine:3.20

# ---------- Build arguments (from CI) ----------
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

RUN addgroup -S ddns && adduser -S ddns -G ddns

RUN apk add --no-cache curl bash jq tzdata

WORKDIR /app
COPY update-dns.sh entrypoint.sh /app/
RUN chmod +x update-dns.sh entrypoint.sh && chown -R ddns:ddns /app

ENV TZ="Europe/Madrid"
ENV CF_TTL=1
ENV CF_PROXIED=false
ENV CF_INTERVAL=300
ENV CF_RECORD_TYPE="A"
ENV APP_VERSION=${VERSION}

USER ddns

ENTRYPOINT ["/app/entrypoint.sh"]
