# Repository guidance

- The Docker Image workflow builds linux/amd64 and linux/arm64. Pull requests build without registry login or publishing; main pushes, manual runs, and scheduled updates publish to Docker Hub and GHCR.
- GHCR images use the lowercase repository owner and the package name `derper`. Use the same `GHCR_IMAGE` for existence checks and publish tags; never derive the package owner from the triggering actor.
- Scheduled checks exchange GitHub credentials for a scoped GHCR registry token. Only HTTP 404 means a missing version; authentication, transport, and server errors must fail the job.
- Validate workflow changes with `actionlint`. Keep Docker Hub credentials in Actions secrets and never print registry tokens.
