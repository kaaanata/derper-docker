# Derper

# Setup

> required: set env `DERP_HOSTNAME` to your domain

```bash
docker run -e DERP_DOMAIN=derper.your-domain.com ghcr.io/kaaanata/derper
```

| env           | required | description                                                  | default value     |
| ------------- | -------- | ------------------------------------------------------------ | ----------------- |
| DERP_HOSTNAME | true     | derper server hostname                                       | your-hostname.com |
| DERP_CERT_DIR | false    | directory to store LetsEncrypt certs(if addr's port is :443) | /app/certs        |
| DERP_ADDR     | false    | listening server address                                     | :443              |
| DERP_DEV_MODE | false    | run in localhost development mode                            | false             |

# Usage

Fully DERP setup offical documentation: https://tailscale.com/kb/1118/custom-derp-servers/
