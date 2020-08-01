# Removes user account and its all related files
# $1: username of the account to revmoved

#!/bin/bash

ACCOUNT=$1
if [ -z "$ACCOUNT" ]
then
    echo "Enter account's username as \$1"
    exit
fi

sudo docker-compose run --rm openvpn ovpn_revokeclient $ACCOUNT remove
rm ../user-profiles/$ACCOUNT.ovpn
