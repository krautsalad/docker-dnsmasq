# docker-dnsmasq

Optimized DNS Forwarder for Docker with Dnsmasq.

**docker-dnsmasq** is an Alpine-based Docker container running [Dnsmasq](https://dnsmasq.org/doc.html). The configuration disables local DNS caching and forwards all DNS requests to Docker's embedded DNS server. This setup allows Dnsmasq to resolve service names and other DNS records provided by Docker.

## Configuration

### Docker Compose Example

```yml
# docker-compose.yml
services:
  dnsmasq:
    container_name: dnsmasq
    image: krautsalad/dnsmasq
    ports:
      - "53:53/udp"
    restart: unless-stopped
```

## How it works

Dnsmasq runs with a configuration that:

- Disables caching: All DNS queries are forwarded without local caching.
- Logs queries: Useful for debugging and monitoring DNS traffic.
- Runs in the foreground: Ensuring it stays as the main container process.
- Forwards to Docker's DNS: Uses the embedded Docker DNS server (127.0.0.11) to resolve container names.

Dnsmasq will be able to resolve all container names in the same Docker network. It is advised to create a custom Docker network (e.g., `docker network create dnsmasq`) and then attach all desired containers—including the dnsmasq container—to that network:

```yml
# docker-compose.yml
networks:
  dnsmasq:
    external: true

services:
  dnsmasq:
    networks:
      - dnsmasq
```

## Source Code

You can find the full source code on [GitHub](https://github.com/krautsalad/docker-dnsmasq).
