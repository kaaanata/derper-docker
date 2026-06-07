# Derper

Minimal Docker image for [Tailscale DERP](https://tailscale.com/kb/1118/custom-derp-servers/) relay servers.  
Tailscale version is auto-synced with [Headscale](https://github.com/juanfont/headscale) for guaranteed compatibility.

**Platforms:** `linux/amd64` · `linux/arm64` · `linux/arm/v7`

## Quick start

```bash
docker run -e DERP_DOMAIN=derp.example.com \
  -p 80:80 -p 443:443 -p 3478:3478/udp \
  ghcr.io/andrewcruz36456/derper
```

## Environment variables

| Variable                         | Default           | Description                                              |
| -------------------------------- | ----------------- | -------------------------------------------------------- |
| `DERP_DOMAIN`                    | your-hostname.com | **Required.** Your DERP server hostname                  |
| `DERP_CERT_MODE`                 | letsencrypt       | Certificate mode: `letsencrypt` or `manual`              |
| `DERP_CERT_DIR`                  | /app/certs        | Certificate directory                                    |
| `DERP_ADDR`                      | :443              | HTTPS listen address                                     |
| `DERP_HTTP_PORT`                 | 80                | HTTP port. Set to `-1` to disable                        |
| `DERP_STUN`                      | true              | Enable STUN server                                       |
| `DERP_STUN_PORT`                 | 3478              | STUN UDP port                                            |
| `DERP_VERIFY_CLIENTS`            | false             | Verify clients via local tailscaled socket               |
| `DERP_VERIFY_CLIENT_URL`         | —                 | Admission controller URL                                 |
| `DERP_VERIFY_CLIENT_URL_FAIL_OPEN` | true            | Allow access if admission controller is unreachable      |
| `TZ`                             | UTC               | Timezone                                                 |

## Manual certificates

```bash
docker run -e DERP_DOMAIN=derp.example.com \
  -e DERP_CERT_MODE=manual \
  -v /etc/letsencrypt/live/derp.example.com/fullchain.pem:/app/certs/derp.example.com.crt:ro \
  -v /etc/letsencrypt/live/derp.example.com/privkey.pem:/app/certs/derp.example.com.key:ro \
  -p 443:443 -p 3478:3478/udp \
  ghcr.io/andrewcruz36456/derper
```

## Client verification

To use `DERP_VERIFY_CLIENTS`, mount the Tailscale socket:

```bash
-v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock
```

For Headscale (v0.24.0+), use the built-in admission controller:

```bash
-e DERP_VERIFY_CLIENT_URL=https://<headscale-domain>/verify
```
