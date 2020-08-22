# Removes user account and its all related files
# $1: username of the account to revmoved

#!/bin/bash
set -e

if [ -z "$1" ]
then
    echo "Enter account's username as \$1"
    exit
fi

ACCOUNT=$1

sudo docker-compose run --rm openvpn ovpn_revokeclient $ACCOUNT remove
rm ../user-profiles/$ACCOUNT.ovpn
