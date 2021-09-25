FROM golang:latest AS builder
WORKDIR /app

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@main

FROM ubuntu
WORKDIR /app

ENV DERP_DOMAIN your-hostname.com
COPY --from=builder /go/bin/derper .
COPY entrypoint.sh /app/entrypoint.sh

CMD ["/app/derper", "--hostname", "${DERP_DOMAIN}"]
