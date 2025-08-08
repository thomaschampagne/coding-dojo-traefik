# Exercise 02 - Map Your First Services Using Traefik Docker Provider & Labels

- [Objective](#objective)
- [Prerequisites](#prerequisites)
- [Required Services](#required-services)
  - [1. Whoami service](#1-whoami-service)
  - [2. Draw service](#2-draw-service)
- [Instructions](#instructions)
  - [Step 1: Complete docker compose.yml](#step-1-complete-docker-composeyml)
  - [Step 2: Complete traefik.yaml](#step-2-complete-traefikyaml)
  - [Step 3: Launch services](#step-3-launch-services)
  - [Step 4: Test access](#step-4-test-access)
- [Tips](#tips)
- [Traefik Labels Reference](#traefik-labels-reference)
- [Expected Result](#expected-result)

## Objective

Set up services using the Docker provider and labels via a docker compose file.

## Prerequisites

- Podman and Podman Compose installed
- Completed Exercise 01 (or copy Traefik configuration)

## Required Services

### 1. Whoami service

- **Image**: `traefik/whoami:v1.11`
- **Access via FQDN**: <http://whoami.dev.dojo.localhost:8080>

### 2. Draw service

- **Image**: `ghcr.io/thomaschampagne/open-draw:latest`
- **Access via FQDN**: <http://draw.dev.dojo.localhost:8080>

## Instructions

### Step 1: Complete docker compose.yml

1. Copy Traefik configuration from Exercise 01
2. Add `whoami` service with proper labels:
   - Enable Traefik with `traefik.enable=true`
   - Set router rule for `whoami.dev.dojo.localhost`
   - Configure entrypoint to use `web`
   - (Optional) Configure the default service `whoami` on `whoami` router w/ `traefik.http.routers.whoami.se(Optional) rvice=whoami`
   - Map container port `80` to the `whoami` service loadbalancer w/ `traefik.http.services.whoami.loadbalancer.server.port=80`

3. Add `draw` service with proper labels:
   - Enable Traefik with `traefik.enable=true`
   - Set router rule for `excalidraw.dev.dojo.localhost`
   - Configure entrypoint to use `web`
   - (Optional) Configure the default service `draw` on `draw` router w/ `traefik.http.routers.draw.service=draw`
   - (Optional) Map container port `80` to the `draw` service loadbalancer w/ `traefik.http.services.draw.loadbalancer.server.port=3000`

### Step 2: Complete traefik.yaml

Copy the configuration from Exercise 01

### Step 3: Launch services

```bash
podman compose -p exercice-02 down; podman compose -p exercice-02 up -d
```

### Step 4: Test access

- Whoami service: <http://whoami.dev.dojo.localhost:8080>
- Draw service: <http://draw.dev.dojo.localhost:8080>
- (Bonus) Traefik service: <http://traefik.dev.dojo.localhost:8080/>

## Tips

- Use Traefik labels to configure routing
- The pattern for router rule: `Host(\`your.domain.localhost\`)`
- Default entrypoint should be `web` for HTTP traffic
- Whoami runs on port 80 inside container.
- OpenDraw runs on port 80 inside container.
- Check Traefik dashboard to see if `routers` & `services` are detected for each service.

## Traefik Labels Reference

Essential labels for service discovery:

- `traefik.enable=true` - Enable Traefik for this service
- `traefik.http.routers.<name>.rule=Host(\`domain.com\`)` - Routing rule
- `traefik.http.routers.<name>.entrypoints=web` - Use web entrypoint
- `traefik.http.services.<name>.loadbalancer.server.port=80` - Service port

## Expected Result

- Traefik dashboard showing 2 detected services
- Whoami service responding with container information
- Draw service accessible with file management interface
