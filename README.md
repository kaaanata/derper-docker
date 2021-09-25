# Derper

# Setup

> required: set env `DERP_HOSTNAME` to your domain

```bash
docker run -e DERP_DOMAIN=derper.your-domain.com -p 80:80 -p 443:443 -p 3478:3478 ghcr.io/kaaanata/derper
```

| env           | required | description                                                  | default value     |
| ------------- | -------- | ------------------------------------------------------------ | ----------------- |
| DERP_HOSTNAME | true     | derper server hostname                                       | your-hostname.com |
| DERP_CERT_DIR | false    | directory to store LetsEncrypt certs(if addr's port is :443) | /app/certs        |
| DERP_ADDR     | false    | listening server address                                     | :443              |
| DERP_STUN     | false    | also run a STUN server                                       | true              |

# Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/
