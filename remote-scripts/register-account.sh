# Registers new user account to the openvpn server and sends .ovpn file to "valerio.ferretti92@gmail.com"
# $1: username of the account to be registered

#!/bin/bash
set -e

if [ -z "$1" ]
then
    echo "Enter account's username as \$1"
    exit
fi

ACCOUNT=$1

sudo docker-compose run --rm openvpn easyrsa build-client-full $ACCOUNT
sudo docker-compose run --rm openvpn ovpn_getclient $ACCOUNT > ../user-profiles/$ACCOUNT.ovpn
