#!/bin/sh
set -ex
docker build --no-cache --progress=plain -t krautsalad/dnsmasq:latest -f Dockerfile .
