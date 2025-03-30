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
    environment:
      TZ: Europe/Berlin
    image: krautsalad/dnsmasq
    ports:
      - "53:53/udp"
    restart: unless-stopped
```

*Note*: To prevent your DNS resolver from being open to all incoming traffic on port 53, drop all other traffic with iptables. For example:

```
/sbin/iptables -N DOCKER-USER
/sbin/iptables -A DOCKER-USER -i eth0 -p tcp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
/sbin/iptables -A DOCKER-USER -i eth0 -p udp -m conntrack --ctorigsrc 172.17.0.0/16 --ctorigdstport 53 -j ACCEPT
/sbin/iptables -A DOCKER-USER -i eth0 -p udp -m conntrack --ctorigsrc 192.168.0.1 --ctorigdstport 53 -j ACCEPT
/sbin/iptables -A DOCKER-USER -i eth0 -p udp -m conntrack --ctorigdstport 53 -j DROP
/sbin/ip6tables -A INPUT -i eth0 -p udp --dport 53 -j DROP
```

Replace `192.168.0.1` with your host's IP address and `eth0` with your network interface name. Ensure these iptables rules are applied on every host reboot (using a startup script or an iptables persistence tool).

### Environment Variables

- `TZ`: Timezone setting (default: UTC).

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
