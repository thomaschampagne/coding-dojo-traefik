# Useful Commands - Exercise 01

## Docker Compose Commands

```bash
# Validate configuration
docker compose config

# Start services (foreground with logs)
docker compose up

# Start services (background)
docker compose up -d

# View logs
docker compose logs -f traefik

# Check service status
docker compose ps

# Stop services
docker compose down

# Stop and remove volumes
docker compose down -v
```

## Testing Commands

```bash
# Test dashboard connectivity
curl -I http://localhost:9000

# Get full Traefik configuration
curl http://localhost:9000/api/rawdata | jq

# Check entrypoints
curl http://localhost:9000/api/entrypoints | jq

# Check providers status
curl http://localhost:9000/api/overview | jq
```

## Debug Commands

```bash
# Inspect Traefik container
docker compose exec traefik sh

# Check Traefik config file
docker compose exec traefik cat /etc/traefik/traefik.yml

# View container details
docker inspect $(docker compose ps -q traefik)

# Check port bindings
docker port $(docker compose ps -q traefik)
```

## Useful URLs

- Traefik Dashboard: http://localhost:9000
- API Documentation: http://localhost:9000/api/rawdata
- Traefik Ping: http://localhost:9000/ping
