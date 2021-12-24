# Derper
![docker workflow](https://github.com/fredliang44/derper-docker/actions/workflows/docker-image.yml/badge.svg) 
![platfrom](https://img.shields.io/badge/platform-amd64%20%7C%20arm64-brightgreen)

# Setup

> required: set env `DERP_DOMAIN` to your domain

```bash
docker run -e DERP_DOMAIN=derper.your-domain.com -p 80:80 -p 443:443 -p 3478:3478 ghcr.io/kaaanata/derper
```

| env           | required | description                                                    | default value     |
| ------------- | -------- | -------------------------------------------------------------- | ----------------- |
| DERP_DOMAIN | true     | derper server hostname                                         | your-hostname.com |
| DERP_CERT_DIR | false    | directory to store LetsEncrypt certs(if addr's port is :443)   | /app/certs        |
| DERP_CERT_MODE| false    | mode for getting a cert. possible options: manual, letsencrypt | letsencrypt       |
| DERP_ADDR     | false    | listening server address                                       | :443              |
| DERP_STUN     | false    | also run a STUN server                                         | true              |

# Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/
