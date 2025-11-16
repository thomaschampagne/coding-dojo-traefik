# Useful Commands - Exercise 01

## Podman Compose Commands

```bash
# Validate configuration
podman compose config

# Start services (foreground with logs)
podman compose up

# Start services (background)
podman compose up -d

# View logs
podman compose logs -f traefik
podman compose logs -f whoami
podman compose logs -f draw

# Check service status
podman compose ps

# Stop services
podman compose down

# Stop and remove volumes
podman compose down -v
```

## Testing Commands

```bash
# Test dashboard connectivity
curl http://traefik.dev.dojo.localhost:8080
curl http://whoami.dev.dojo.localhost:8080
curl http://draw.dev.dojo.localhost:8080
```

## Debug Commands

```bash
# List containers
podman ps -a

# Connect to containers
podman compose exec -it traefik sh
podman compose exec -it draw sh

# View container details
podman inspect $(podman compose ps -q traefik)

# Check port bindings
podman port $(podman compose ps -q traefik)
```
