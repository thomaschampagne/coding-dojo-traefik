# Exercise 01 - Initialize Podman Compose with Traefik Reverse Proxy and Dashboard

- [Objective](#objective)
- [Prerequisites](#prerequisites)
- [Instructions](#instructions)
  - [Step 1: Complete Podman compose.yml](#step-1-complete-podman-composeyml)
  - [Step 2: Complete traefik.yaml](#step-2-complete-traefikyaml)
  - [Step 3: Launch environment](#step-3-launch-environment)
  - [Step 4: Verify](#step-4-verify)
- [Tips](#tips)
- [Expected Result](#expected-result)

## Objective

Set up a Podman Compose environment with Traefik as reverse proxy and dashboard access.

## Prerequisites

- Podman and Podman Compose installed
- Ports 8080, 8443 and 9000 available on your host/vm

## Instructions

### Step 1: Complete Podman compose.yml

1. Specify Traefik image (version 3.5)
2. Configure ports `host:container` (`8080:3080`, `8443:3443`, `9000:8080`)
3. Mount necessary volumes:
   - Podman socket directly from linux: `/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro`
   - Docker/Podman use instead socket: `/var/run/docker.sock:/var/run/docker.sock:ro`
   - Traefik configuration: `./traefik.yaml:/etc/traefik/traefik.yaml:ro`
4. Edit Traefik to:
   - Enable Docker provider inside Traefik
   - Define internal Traefik entrypoints:
      - Port `3080` for HTTP (`web` entrypoint)
      - Port `3443` for HTTPS (`websecure` entrypoint)
   - Enable API and Dashboard
   - Enable Logs (level info)

### Step 2: Complete traefik.yaml

1. Define `web` and `websecure` entrypoints
2. Configure Docker provider
3. Enable API and dashboard

### Step 3: Launch environment

```bash
podman compose -p exercice-01 down; podman compose -p exercice-01 up -d
```

### Step 4: Verify

- Check `Traefik` dashboard at <http://localhost:9000> properly working
- Then `Traefik` API: <http://localhost:9000/api/rawdata>

## Tips

- Check Traefik v3.5 documentation if needed
- Podman volumes should be mounted read-only (`:ro`)

## Expected Result

Once completed, you should have:

- A functional Traefik service
- Dashboard accessible on <http://localhost:9000>
- Configured `web` and `websecure` entrypoints
