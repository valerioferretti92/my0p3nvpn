# Creates openvpn configuration and initializes certificate authority
# $1: openvpn server's domain name / public IP address

#!/bin/bash
set -e

if [ -z "$1" ]
then
    echo "Enter domain name or IP address as \$1"
    exit
fi

DOMAIN=$1

mkdir -p ../openvpn-conf
mkdir -p ../user-profiles

sudo docker-compose run --rm openvpn ovpn_genconfig -u udp://$DOMAIN
sudo docker-compose run --rm openvpn ovpn_initpki

