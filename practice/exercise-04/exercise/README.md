# Exercise 04 – Secure Traefik Endpoint with a Certificate Signed by a `Fake Coding Dojo Certificate Authority`

- [Prerequisites](#prerequisites)
- [Instructions](#instructions)
  - [Step 1: Mount the certs folder inside Traefik](#step-1-mount-the-certs-folder-inside-traefik)
  - [Step 2: Root CA Client Installation](#step-2-root-ca-client-installation)
  - [Step 3: Mount a new Traefik TLS configuration file provider](#step-3-mount-a-new-traefik-tls-configuration-file-provider)
  - [Step 4: Setup Traefik TLS configuration using the new dedicated file provider](#step-4-setup-traefik-tls-configuration-using-the-new-dedicated-file-provider)
  - [Step 5: Remove non-secure `http` port mapping (`host:container`)](#step-5-remove-non-secure-http-port-mapping-hostcontainer)
  - [Step 6: Remove `web` entrypoint for `websecure` use only on services](#step-6-remove-web-entrypoint-for-websecure-use-only-on-services)
  - [Step 7: Enable `tls` on all services](#step-7-enable-tls-on-all-services)
  - [Step 8: Launch services](#step-8-launch-services)
  - [Step 9: Test secured endpoints](#step-9-test-secured-endpoints)
  - [Step 10: (Bonus) Add Security Headers to All Services (HSTS headers, IFrame injection blocking, Browser XSS filter, ...)](#step-10-bonus-add-security-headers-to-all-services-hsts-headers-iframe-injection-blocking-browser-xss-filter-)

## Prerequisites

- Podman and Podman Compose installed
- Completed Exercise 03 (understanding of middlewares)

## Instructions

### Step 1: Mount the certs folder inside Traefik

> For this exercice certificate/key are already generated to save time.

- Mount the certificates directory (`./certs`) inside Traefik under `/certs`.

> Note: Certificate and key are located in `./practice/exercise-04/exercise/certs/`:
>
> - `default.crt`: Trust-chain of the wildcard certificate matching domain `*.dev.dojo.localhost` concatenated with `Fake Coding Dojo Certificate Authority` certificate.
> - `default.key`: private key of `default.crt`.
> - `root-ca.crt`: `Fake Coding Dojo Certificate Authority` certificate. Note: This authority has signed `default.crt` with his private key (not committed).

### Step 2: Root CA Client Installation

Install `./practice/exercise-04/exercise/certs/root-ca.crt` certificate on your host to ensure that certificates signed by `Fake Coding Dojo Certificate Authority` can be trusted.

To install it on `Windows`:

- Double-click the certificate file.
- Select the `User Certificate` option.
- Choose the `Trusted Root Certification Authorities` store.

> Note: You can delete it from your keychain afterward.

### Step 3: Mount a new Traefik TLS configuration file provider

- Mount `tls.yaml` as a file provider inside Traefik under `/etc/traefik/file-providers` folder.

### Step 4: Setup Traefik TLS configuration using the new dedicated file provider

- Configure `tls.yaml` to have:
  - `default.crt` & `default.key` cert/key file defined in a default Traefik certificates store.
  - TLS version 1.2 minimum supported.

> See TLS doc: <https://doc.traefik.io/traefik/https/tls/>

### Step 5: Remove non-secure `http` port mapping (`host:container`)

- Remove the HTTP port mapping `8080:3080` from the Traefik container to enforces HTTPS-only access on host.

### Step 6: Remove `web` entrypoint for `websecure` use only on services

- Remove the `web` (HTTP) entrypoint to keep only the `websecure` (HTTPS) entrypoint on all services.

### Step 7: Enable `tls` on all services

- Make sure every Traefik router has `tls=true` label enabled for HTTPS routing.

### Step 8: Launch services

```bash
podman compose -p exercice-04 down; podman compose -p exercice-04 up -d
```

### Step 9: Test secured endpoints

- Close your browser or open private session to get `Fake Coding Dojo Certificate Authority` certificate recognized browser
- Open in your browser:
  - Whoami service: <https://whoami.dev.dojo.localhost:8443>
  - Draw service: <https://draw.dev.dojo.localhost:8443>
  - Traefik service: <https://traefik.dev.dojo.localhost:8443>
- Verify endpoints are trusted by browser
- Look at websites trust-chain in site information panel (left to url).
- Check Traefik dashboard to see secured services.

### Step 10: (Bonus) Add Security Headers to All Services (HSTS headers, IFrame injection blocking, Browser XSS filter, ...)

Tip: You might use below middleware as base & [HTTP Middlewares](https://doc.traefik.io/traefik/middlewares/http/overview/) documentation

```yaml
http:
  middlewares:
    secure-headers:
      headers:
        forceSTSHeader: true # Forces the Strict-Transport-Security (STS) header to be added, even if the request is over HTTP (not HTTPS).
        frameDeny: true # Adds the `X-Frame-Options: DENY` header to prevent the site from being embedded in iframes.
        stsIncludeSubdomains: true # Applies the STS policy to all subdomains as well.
        stsPreload: true # Indicates to browsers that this domain should be preloaded into their HSTS lists.
        stsSeconds: 63072000 # Sets the STS header's max-age to 2 years (in seconds).
        contentTypeNosniff: true # Adds the `X-Content-Type-Options: nosniff` header to prevent MIME type sniffing.
        browserXssFilter: true # Adds the `X-XSS-Protection: 1; mode=block` header to enable browser-based XSS filters.
        referrerPolicy: strict-origin # Specifies the referrer policy for links to send only the origin in the Referer header.
```
