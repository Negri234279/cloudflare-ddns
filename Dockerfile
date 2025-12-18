FROM alpine:3.20

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

USER ddns

ENTRYPOINT ["/app/entrypoint.sh"]
