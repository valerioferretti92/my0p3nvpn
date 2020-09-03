#!/bin/bash
set -e

if [ -z "$1" ];
then
    echo "Enter key pair name as \$1"
    exit
fi

KEY_PAIR_NAME=$1

KEY_PAIR_CHECK=$(aws ec2 describe-key-pairs --profile my0p3nvpn | grep $KEY_PAIR_NAME | cat)
if [ -z "$KEY_PAIR_CHECK" ];
then
    mkdir -p ~/.aws/my0p3nvpnkeys/
    aws ec2 create-key-pair \
        --key-name $KEY_PAIR_NAME \
        --query 'KeyMaterial' \
        --output text > ~/.aws/my0p3nvpnkeys/$KEY_PAIR_NAME.pem \
        --profile my0p3nvpn
    chmod 600 ~/.aws/my0p3nvpnkeys/$KEY_PAIR_NAME.pem
    exit
fi

echo "Nothing to be done"
