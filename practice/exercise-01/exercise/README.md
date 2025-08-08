# Exercise 01 - Initialize Docker Compose with Traefik Reverse Proxy and Dashboard

## Objective
Set up a Docker Compose environment with Traefik as reverse proxy and dashboard access.

## Prerequisites
- Docker and Docker Compose installed
- Ports 80, 443 and 9000 available on your machine

## Instructions

### Step 1: Complete docker compose.yml
1. Specify Traefik image (version 2.10)
2. Configure ports (80, 443, 9000)
3. Mount necessary volumes:
   - Docker socket: `/var/run/docker.sock:/var/run/docker.sock:ro`
   - Traefik configuration: `./traefik.yml:/etc/traefik/traefik.yml:ro`
4. Add command arguments for:
   - Enable Docker provider
   - Define entrypoints
   - Enable API and dashboard
5. Configure labels to expose dashboard

### Step 2: Complete traefik.yml
1. Define `web` and `websecure` entrypoints
2. Configure Docker provider
3. Enable API and dashboard

### Step 3: Launch environment
```bash
docker compose up -d
```

### Step 4: Verify
- Access Traefik dashboard: http://localhost:9000
- Check that services appear in the interface

## Tips
- Check Traefik v2.10 documentation if needed
- Docker volumes should be mounted read-only (`:ro`)
- Don't forget to create a network for your services

## Expected Result
Once completed, you should have:
- A functional Traefik service
- Dashboard accessible on http://localhost:9000
- Configured web and websecure entrypoints
- Automatic Docker container monitoring
