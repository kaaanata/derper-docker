FROM golang:latest AS builder
WORKDIR /app

# https://tailscale.com/kb/1118/custom-derp-servers/
RUN go install tailscale.com/cmd/derper@main

FROM ubuntu
WORKDIR /app

RUN mkdir /app/cert

ENV DERP_DOMAIN your-hostname.com
ENV DERP_CERT_DIR /app/certs
ENV DERP_ADDR :443
ENV DERP_DEV_MODE false

COPY --from=builder /go/bin/derper .

CMD ["/app/derper", "--hostname", "${DERP_DOMAIN}", "--cert-dir", "${DERP_CERT_DIR}", "--a", "${DERP_ADDR}", "--dev", "${DERP_DEV_MODE}"]
