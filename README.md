# Derper

[![docker workflow](https://github.com/fredliang44/derper-docker/actions/workflows/docker-image.yml/badge.svg)](https://ghcr.io/kaaanata/derper)
[![docker pulls](https://img.shields.io/docker/pulls/ghcr.io/kaaanata/derper.svg?color=brightgreen)](https://hub.docker.com/r/ghcr.io/kaaanata/derper)
[![platfrom](https://img.shields.io/badge/platform-amd64%20%7C%20arm64-brightgreen)](https://ghcr.io/kaaanata/derper/tags)

# Setup

> required: set env `DERP_DOMAIN` to your domain

```bash
docker run -e DERP_DOMAIN=derper.your-domain.com -p 80:80 -p 443:443 -p 3478:3478/udp ghcr.io/kaaanata/derper
```

| env                              | required | description                                                                        | default value     |
| -------------------------------- | -------- | ---------------------------------------------------------------------------------- | ----------------- |
| DERP_DOMAIN                      | true     | derper server hostname                                                             | your-hostname.com |
| DERP_CERT_DIR                    | false    | directory to store LetsEncrypt certs(if addr's port is :443)                       | /app/certs        |
| DERP_CERT_MODE                   | false    | mode for getting a cert. possible options: manual, letsencrypt                     | letsencrypt       |
| DERP_ADDR                        | false    | listening server address                                                           | :443              |
| DERP_STUN                        | false    | also run a STUN server                                                             | true              |
| DERP_STUN_PORT                   | false    | The UDP port on which to serve STUN.                                               | 3478              |
| DERP_HTTP_PORT                   | false    | The port on which to serve HTTP. Set to -1 to disable                              | 80                |
| DERP_VERIFY_CLIENTS              | false    | verify clients to this DERP server through a local tailscaled instance             | false             |
| DERP_VERIFY_CLIENT_URL           | false    | if non-empty, an admission controller URL for permitting client connections        | ""                |
| DERP_VERIFY_CLIENT_URL_FAIL_OPEN | false    | whether to fail open (allow access) if the `DERP_VERIFY_CLIENT_URL` is unreachable | true              |

# Usage

Fully DERP setup offical documentation: [https://tailscale.com/kb/1118/custom-derp-servers/]()

## Client verification

In order to use `DERP_VERIFY_CLIENTS`, the container needs access to Tailscale's Local API, which can usually be accessed through `/var/run/tailscale/tailscaled.sock`. If you're running Tailscale bare-metal on Linux, adding this to the `docker run` command should be enough: `-v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock`

## Client verification

In order to use `DERP_VERIFY_CLIENTS`, the container needs access to Tailscale's Local API, which can usually be accessed through `/var/run/tailscale/tailscaled.sock`. If you're running Tailscale bare-metal on Linux, adding this to the `docker run` command should be enough: `-v /var/run/tailscale/tailscaled.sock:/var/run/tailscale/tailscaled.sock`

## Client verification URL

`DERP_VERIFY_CLIENT_URL` is an environment variable that allows you to set up client admission control for your DERP server.

### How it works:

1. When a Tailscale client tries to connect to your DERP server
2. The DERP server makes a POST request to your verification URL
3. Your endpoint returns {"allow": true} or {"allow": false}
4. The DERP server accepts or rejects the client based on your response

### JSON Specification

**Request** (sent by DERP to `DERP_VERIFY_CLIENT_URL`):

```
{
"nodePublic": "nodekey:abc123...",
"source": "192.168.1.100"
}
```

**Response** (expected from server):

```
{
"allow": true
}
```

### Handling Verification Failures

If the verification URL is unreachable (e.g., network timeout, server down), the system behavior is determined by the `DERP_VERIFY_CLIENT_URL_FAIL_OPEN` environment variable.

- **Default Behavior: Fail Open**
  By default (`true`), if the verification check fails to execute, the DERP server ​**ALLOWs the connection**​. This ensures service availability even if the auth server is offline. Set to `false` to REJECT connections if the verification server is unreachable.

### Integration with Headscale

> [!NOTE]
> This feature requires Headscale **v0.24.0** or later. See [PR #2046](https://github.com/juanfont/headscale/pull/2046) and [Document](https://headscale.net/0.27.0/ref/derp/#verify-clients) (Since 0.27.0) for details.

[Headscale](https://github.com/juanfont/headscale) natively supports the DERP verification protocol. This allows your DERP server to verify clients directly against the Headscale node list.

To enable this, point the verification URL to your Headscale instance's `/verify` endpoint:

```bash
DERP_VERIFY_CLIENT_URL="https://<your-headscale-domain>/verify"
```

