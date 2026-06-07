FROM --platform=$BUILDPLATFORM golang:alpine AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG TARGETVARIANT
ARG DERP_VERSION=latest

ENV CGO_ENABLED=0 \
    GOOS=$TARGETOS \
    GOARCH=$TARGETARCH

RUN if [ "$TARGETARCH" = "arm" ] && [ -n "$TARGETVARIANT" ]; then \
        export GOARM="${TARGETVARIANT#v}"; \
    fi && \
    go install tailscale.com/cmd/derper@${DERP_VERSION}

FROM alpine

RUN apk add --no-cache ca-certificates tzdata wget && mkdir -p /app/certs

ENV DERP_DOMAIN=your-hostname.com \
    DERP_CERT_MODE=letsencrypt \
    DERP_CERT_DIR=/app/certs \
    DERP_ADDR=:443 \
    DERP_STUN=true \
    DERP_STUN_PORT=3478 \
    DERP_HTTP_PORT=80 \
    DERP_VERIFY_CLIENTS=false \
    DERP_VERIFY_CLIENT_URL="" \
    DERP_VERIFY_CLIENT_URL_FAIL_OPEN=true \
    TZ=UTC

COPY --from=builder /go/bin/derper /app/derper
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD nc -z -w3 localhost 443 || exit 1

ENTRYPOINT ["/entrypoint.sh"]
