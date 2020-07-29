#!/bin/bash

DOMAIN=$1
if [ -z "$DOMAIN" ]
then
    echo "Enter domain name or IP address as \$1"
    exit
fi

mkdir -p ../openvpn-conf
mkdir -p ../user-profiles

docker-compose run --rm openvpn ovpn_genconfig -u udp://$DOMAIN
docker-compose run --rm openvpn ovpn_initpki
sudo chown -R $(whoami): ../openvpn-conf

