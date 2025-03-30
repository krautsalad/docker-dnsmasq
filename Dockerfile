ARG DNSMASQ_VERSION=2.91

FROM dockurr/dnsmasq:${DNSMASQ_VERSION}
COPY ./dnsmasq/dnsmasq.conf /etc/dnsmasq.conf
