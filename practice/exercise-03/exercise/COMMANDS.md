# Useful Commands - Exercise 03

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

## Password Generation Commands

```bash
# Generate bcrypt hash for password "dojo"
podman run --rm httpd:2.4-alpine htpasswd -nbB dojo dojo | sed -e s/\\$/\\$\\$/g
```

## Debug Commands

```bash
# List containers
podman ps -a

# Connect to containers
podman compose exec -it traefik sh
podman compose exec -it whoami sh
podman compose exec -it draw sh

# View container details
podman inspect $(podman compose ps -q traefik)

# Check middleware file loading
podman compose logs traefik | grep -i middleware
podman compose logs traefik | grep -i file
```
