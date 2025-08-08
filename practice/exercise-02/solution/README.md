# Exercise 02 - SOLUTION
# Map Your First Services Using Docker Provider & Labels

## Complete Solution

This solution demonstrates how to use Traefik's Docker provider to automatically discover and route services using labels.

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                    Traefik                          │
│                 (Port 80, 443, 9000)               │
└─────────────────┬─────────────┬─────────────────────┘
                  │             │
                  ▼             ▼
      ┌─────────────────┐   ┌─────────────────┐
      │     Whoami      │   │   Filebrowser   │
      │ whoami.dev.dojo │   │ files.dev.dojo  │
      │   .localhost    │   │   .localhost    │
      └─────────────────┘   └─────────────────┘
```

## Services Implemented

### 1. Traefik Service
- **Image**: `traefik:v2.10`
- **Ports**: 80 (HTTP), 443 (HTTPS), 9000 (Dashboard)
- **Volumes**: Docker socket + traefik.yml config
- **Features**: Docker provider, API, Dashboard

### 2. Whoami Service
- **Image**: `traefik/whoami:v1.11`
- **Access**: http://whoami.dev.dojo.localhost
- **Purpose**: Simple service that returns container information
- **Labels**: Configured for Traefik routing

### 3. Filebrowser Service
- **Image**: `filebrowser/filebrowser:v2.42.2`
- **Access**: http://files.dev.dojo.localhost
- **Purpose**: Web-based file manager
- **Volume**: Persistent storage for files
- **Labels**: Configured for Traefik routing

## Key Traefik Labels Explained

### Essential Labels
```yaml
labels:
  # Enable service discovery
  - "traefik.enable=true"

  # Define routing rule
  - "traefik.http.routers.<service>.rule=Host(`domain.localhost`)"

  # Specify entrypoint
  - "traefik.http.routers.<service>.entrypoints=web"

  # Define service port
  - "traefik.http.services.<service>.loadbalancer.server.port=80"
```

### Label Components
- **Router**: Defines how requests are matched and forwarded
- **Service**: Defines backend servers and load balancing
- **Rule**: Matching criteria (Host, Path, Headers, etc.)
- **Entrypoint**: Which port/protocol to use

## Setup Instructions

### 1. Local DNS Resolution
Add to `/etc/hosts` (Linux/Mac) or `C:\Windows\System32\drivers\etc\hosts` (Windows):
```
127.0.0.1 whoami.dev.dojo.localhost
127.0.0.1 files.dev.dojo.localhost
```

### 2. Launch Services
```bash
# Navigate to solution directory
cd solution

# Start all services
docker compose up -d

# Check status
docker compose ps
```

### 3. Verify Services
```bash
# Test whoami service
curl http://whoami.dev.dojo.localhost

# Check Traefik dashboard
open http://localhost:9000
```

## Testing and Validation

### Service Health Checks
```bash
# Check all containers are running
docker compose ps

# View Traefik logs
docker compose logs traefik

# Test service responses
curl -H "Host: whoami.dev.dojo.localhost" http://localhost
curl -H "Host: files.dev.dojo.localhost" http://localhost
```

### Dashboard Verification
- **URL**: http://localhost:9000
- **Features**:
  - Service discovery status
  - Router configurations  
  - Real-time metrics
  - HTTP routes overview

## Advanced Features

### Service Discovery
Traefik automatically:
- Detects new containers with `traefik.enable=true`
- Creates routes based on labels
- Updates routing when containers start/stop
- Load balances multiple instances

### Security Considerations
- `exposedByDefault: false` - Only labeled services are exposed
- Read-only Docker socket mount
- API in insecure mode (development only)

## Troubleshooting

### Common Issues
1. **Service not accessible**: Check `/etc/hosts` entries
2. **404 errors**: Verify Traefik labels syntax
3. **Container not detected**: Ensure `traefik.enable=true`
4. **Port conflicts**: Check if ports 80/443/9000 are available

### Debug Commands
```bash
# Check Traefik configuration
docker compose exec traefik cat /etc/traefik/traefik.yml

# View detected services
curl http://localhost:9000/api/http/services | jq

# Check routers
curl http://localhost:9000/api/http/routers | jq
```

## Next Steps
- Add HTTPS with automatic certificates
- Implement middleware (authentication, rate limiting)
- Add monitoring with metrics
- Scale services with multiple replicas
