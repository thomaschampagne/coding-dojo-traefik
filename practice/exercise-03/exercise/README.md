# Exercise 03 – Add Middlewares using Docker provider and File providers

- [Prerequisites](#prerequisites)
- [Required Middlewares](#required-middlewares)
  - [1. "Token Bucket" Rate Limiter Middleware (File Provider Only)](#1-token-bucket-rate-limiter-middleware-file-provider-only)
  - [2. Simple Basic Authentication Middleware (Docker Provider Only)](#2-simple-basic-authentication-middleware-docker-provider-only)
- [Instructions](#instructions)
  - [Step 1: Complete traefik.yaml](#step-1-complete-traefikyaml)
  - [Step 2: Create `whoami-rate-limiter` in middlewares.yaml](#step-2-create-whoami-rate-limiter-in-middlewaresyaml)
  - [Step 3: Complete `whoami` compose.yaml](#step-3-complete-whoami-composeyaml)
  - [Step 4: Create inline `draw-auth` middleware inside compose.yaml](#step-4-create-inline-draw-auth-middleware-inside-composeyaml)
  - [Step 5: Launch services](#step-5-launch-services)
  - [Step 6: Test middlewares](#step-6-test-middlewares)
- [Tips](#tips)

## Prerequisites

- Podman and Podman Compose installed
- Completed Exercise 02 (or copy Traefik configuration)

## Required Middlewares

### 1. "Token Bucket" Rate Limiter Middleware (File Provider Only)

- **Applied to**: `whoami` service
- **Configuration**: 1 request per second, burst of 1, period 1s
- **Implementation**: Using middlewares.yaml file (= Traefik File Provider)

> Token bucket wikipedia: <https://en.wikipedia.org/wiki/Token_bucket>
> Token bucket animation: <https://smudge.ai/blog/ratelimit-algorithms>

### 2. Simple Basic Authentication Middleware (Docker Provider Only)

- **Applied to**: `draw` service  
- **Credentials**: Username `dojo`, Password `dojo`
- **Implementation**: Using container labels in compose file (= Traefik Docker Provider)

> Basic access authentication wikipedia: <https://en.wikipedia.org/wiki/Basic_access_authentication>

## Instructions

### Step 1: Complete traefik.yaml

1. Copy Traefik configuration from Exercise 02
2. Add File provider configuration:
   - Enable file provider with directory `/etc/traefik/file-providers`
   - Enable watch for file changes

> See file provider doc:<https://doc.traefik.io/traefik/providers/file/>

### Step 2: Create `whoami-rate-limiter` in middlewares.yaml

- Define a rate limiting middleware inside `middlewares.yaml` file:
  - Name: `whoami-rate-limiter`
  - Average: `1` request per second
  - Burst: `1` request
  - Period: `1s`

This configuration file will be loaded by Traefik File Provider just after

> See middlewares doc: <https://doc.traefik.io/traefik/middlewares/http/overview/>
> See RateLimit middleware doc:  <https://doc.traefik.io/traefik/middlewares/http/ratelimit/>

### Step 3: Complete `whoami` compose.yaml

1. Copy `whoami` services from Exercise 02
2. Mount `middlewares.yaml` file in Traefik container toward `/etc/traefik/file-providers/middlewares.yaml`.
3. Add middleware reference to whoami router. Use: `traefik.http.routers.<my-router>.middlewares=<my-middleware-name>@<provider-ref>`

### Step 4: Create inline `draw-auth` middleware inside compose.yaml

1. Copy `draw` services from Exercise 02
2. Create inline middleware `BasicAuth` with params:
   - Name: `whoami-auth`
   - Username: `dojo`
   - Password: `dojo`
3. Map/Assign the inline BasicAuth middleware creater to the `draw` router.

> Generate user w/ bcrypt hashed password using: `podman run --rm httpd:2.4-alpine htpasswd -nbB dojo dojo | sed -e s/\\$/\\$\\$/g` => `dojo:$$2y$$05$$SzmoZ53EBGjqccpkwkiZ4.hKJUEj7pKNVb43HQkg9eZsdvzCiuGsG`
>
> See `BasicAuth` middleware doc:<https://doc.traefik.io/traefik/middlewares/http/basicauth/>

### Step 5: Launch services

```bash
podman compose -p exercice-03 down; podman compose -p exercice-03 up -d
```

### Step 6: Test middlewares

- Rate limiting: Open <http://whoami.dev.dojo.localhost:8080> (try spam / multiple rapid requests). A `429 Too Many Requests` should be returned by Traefik. Retry few seconds later to get it working again.
- Basic auth: Open <http://draw.dev.dojo.localhost:8080>. Authentication should pass with `dojo:dojo` credentials. A `401 Unauthorized` should be returned by Traefik w/ wrong credentials.

## Tips

- Use `@file` or `@docker` syntax to reference `file/docker` providers middlewares. Note that `@internal` also exists (see `traefik.dev.dojo.localhost` traefik config).
- Check Traefik dashboard to see services chaining from `Entrypoints` > `Routers` > `Middleware` > `Services`.
