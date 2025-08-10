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
curl -I http://localhost:9000
```

## Debug Commands

```bash
# List containers
podman ps -a

# Inspect Traefik container
podman compose exec -it traefik sh

# Check Traefik config file
podman compose exec traefik cat /etc/traefik/traefik.yaml

# View container details
podman inspect $(podman compose ps -q traefik)

# Check port bindings
podman port $(podman compose ps -q traefik)
```
