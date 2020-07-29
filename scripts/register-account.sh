#!/bin/bash

ACCOUNT=$1
if [ -z "$ACCOUNT" ]
then
    echo "Enter account's username as \$1"
    exit
fi

docker-compose run --rm openvpn easyrsa build-client-full $ACCOUNT
docker-compose run --rm openvpn ovpn_getclient $ACCOUNT > ../user-profiles/$ACCOUNT.ovpn
