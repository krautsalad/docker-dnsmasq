ARG DNSMASQ_VERSION=2.91

FROM dockurr/dnsmasq:${DNSMASQ_VERSION}

RUN apk update && \
    apk add --no-cache tzdata && \
    rm -rf /root/.cache /tmp/* /var/cache/apk/* /var/tmp/

COPY ./dnsmasq/dnsmasq.conf /etc/dnsmasq.conf
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/sbin/tini", "--", "/usr/bin/dnsmasq.sh"]
