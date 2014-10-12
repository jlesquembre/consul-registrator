#!/bin/bash

# requires more utils
#ip=`ifdata -pa $1`



if [[ $# -ne 2 || $1 != @(start|stop) ]]; then
    exit_error "Usage: $0 {start|stop} <interface>"
fi

interface=$2
case $1 in
    start)
        ip=`ip -o -4 addr list $interface | awk '{print $4}' | cut -d/ -f1`

        /usr/bin/docker run -d --name consul -h $HOSTNAME \
            -e SERVICE_NAME=consul \
            -p $ip:8300:8300 \
            -p $ip:8301:8301 \
            -p $ip:8301:8301/udp \
            -p $ip:8302:8302 \
            -p $ip:8302:8302/udp \
            -p $ip:8400:8400 \
            -p $ip:8500:8500 \
            -p 172.17.42.1:53:53/udp \
            progrium/consul -bootstrap -server -advertise $ip

        lines=("domain service.consul" "nameserver 172.17.42.1")
        printf "%s\n" "${lines[@]}" | resolvconf -m 1 -a consul

        docker run -d --name registrator -h $HOSTNAME \
            -v /var/run/docker.sock:/tmp/docker.sock \
            progrium/registrator consul://consul.service.consul:8500
    ;;
    stop)
        resolvconf -d consul
        docker stop consul registrator
        docker rm consul registrator
    ;;
esac
