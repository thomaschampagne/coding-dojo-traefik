# Useful Commands - Exercise 02

## Docker Compose Commands
```bash
# Validate configuration
docker compose config

# Start all services
docker compose up -d

# Check all containers status
docker compose ps

# View logs for specific service
docker compose logs -f traefik
docker compose logs -f whoami
docker compose logs -f filebrowser

# Stop all services
docker compose down
```

## Service Testing Commands
```bash
# Test with Host headers (when DNS not configured)
curl -H "Host: whoami.dev.dojo.localhost" http://localhost
curl -H "Host: files.dev.dojo.localhost" http://localhost

# Test with actual domains (requires /etc/hosts setup)
curl http://whoami.dev.dojo.localhost
curl http://files.dev.dojo.localhost

# Get service information from whoami
curl -s http://whoami.dev.dojo.localhost | grep -E "(Hostname|IP)"
```

## Traefik API Commands
```bash
# List all discovered services
curl http://localhost:9000/api/http/services | jq

# List all routers
curl http://localhost:9000/api/http/routers | jq

# Check specific service
curl http://localhost:9000/api/http/services/whoami@docker | jq
curl http://localhost:9000/api/http/services/filebrowser@docker | jq

# View router rules
curl http://localhost:9000/api/http/routers/whoami@docker | jq
curl http://localhost:9000/api/http/routers/filebrowser@docker | jq
```

## DNS Setup Commands
```bash
# Linux/Mac - Add to /etc/hosts
echo "127.0.0.1 whoami.dev.dojo.localhost" | sudo tee -a /etc/hosts
echo "127.0.0.1 files.dev.dojo.localhost" | sudo tee -a /etc/hosts

# Windows - Add to C:\Windows\System32\drivers\etc\hosts
# (Run as Administrator)
echo 127.0.0.1 whoami.dev.dojo.localhost >> C:\Windows\System32\drivers\etc\hosts
echo 127.0.0.1 files.dev.dojo.localhost >> C:\Windows\System32\drivers\etc\hosts

# Verify DNS resolution
nslookup whoami.dev.dojo.localhost
nslookup files.dev.dojo.localhost
```

## Debug Commands
```bash
# Check container networks
docker network ls
docker network inspect $(docker compose ps -q traefik | head -1 | xargs docker inspect -f '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}')

# Inspect service labels
docker inspect $(docker compose ps -q whoami) | jq '.[].Config.Labels'
docker inspect $(docker compose ps -q filebrowser) | jq '.[].Config.Labels'

# Check internal connectivity
docker compose exec traefik ping whoami
docker compose exec traefik ping filebrowser
```

## Useful URLs
- Traefik Dashboard: http://localhost:9000
- Whoami Service: http://whoami.dev.dojo.localhost
- Filebrowser Service: http://files.dev.dojo.localhost
- API Services: http://localhost:9000/api/http/services
- API Routers: http://localhost:9000/api/http/routers
