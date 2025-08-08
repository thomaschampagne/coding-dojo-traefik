# Exercise 02 - Map Your First Services Using Docker Provider & Labels

## Objective
Set up services using the Docker provider and labels via a docker compose file.

## Prerequisites
- Docker and Docker Compose installed
- Completed Exercise 01 (or copy Traefik configuration)
- Add entries to your `/etc/hosts` file for local domain resolution

## Required Services

### 1. whoami service
- **Image**: `traefik/whoami:v1.11`
- **Access via FQDN**: http://whoami.dev.dojo.localhost

### 2. filebrowser service
- **Image**: `filebrowser/filebrowser:v2.42.2`
- **Access via FQDN**: http://files.dev.dojo.localhost

## Instructions

### Step 1: Setup local DNS resolution
Add these entries to your `/etc/hosts` file (or `C:\Windows\System32\drivers\etc\hosts` on Windows):
```
127.0.0.1 whoami.dev.dojo.localhost
127.0.0.1 files.dev.dojo.localhost
```

### Step 2: Complete docker compose.yml
1. Copy Traefik configuration from Exercise 01
2. Add whoami service with proper labels:
   - Enable Traefik with `traefik.enable=true`
   - Set router rule for `whoami.dev.dojo.localhost`
   - Configure entrypoint to use `web`
3. Add filebrowser service with proper labels:
   - Enable Traefik with `traefik.enable=true`
   - Set router rule for `files.dev.dojo.localhost`
   - Configure entrypoint to use `web`
   - Set service port to 80 (filebrowser default port)

### Step 3: Complete traefik.yml
Copy the configuration from Exercise 01

### Step 4: Launch services
```bash
docker compose up -d
```

### Step 5: Test access
- Traefik dashboard: http://localhost:9000
- Whoami service: http://whoami.dev.dojo.localhost
- Filebrowser service: http://files.dev.dojo.localhost

## Tips
- Use Traefik labels to configure routing
- The pattern for router rule: `Host(\`your.domain.localhost\`)`
- Default entrypoint should be `web` for HTTP traffic
- Filebrowser runs on port 80 inside container
- Check Traefik dashboard to see if services are detected

## Traefik Labels Reference
Essential labels for service discovery:
- `traefik.enable=true` - Enable Traefik for this service
- `traefik.http.routers.<name>.rule=Host(\`domain.com\`)` - Routing rule
- `traefik.http.routers.<name>.entrypoints=web` - Use web entrypoint
- `traefik.http.services.<name>.loadbalancer.server.port=80` - Service port

## Expected Result
- Traefik dashboard showing 2 detected services
- Whoami service responding with container information
- Filebrowser service accessible with file management interface
