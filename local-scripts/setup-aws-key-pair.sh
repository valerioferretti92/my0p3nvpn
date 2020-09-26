#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ];
then
    echo "Enter region as \$1, key pair name as \$2"
    exit
fi

REGION=$1
KEY_PAIR_NAME=$2

KEY_PAIR_CHECK=$(aws ec2 describe-key-pairs --region $REGION --profile my0p3nvpn | grep $KEY_PAIR_NAME | cat)
if [ -z "$KEY_PAIR_CHECK" ];
then
    mkdir -p ~/.aws/my0p3nvpnkeys/
    aws ec2 create-key-pair \
        --key-name $KEY_PAIR_NAME \
        --query 'KeyMaterial' \
        --output text > ~/.aws/my0p3nvpnkeys/$KEY_PAIR_NAME.pem \
        --region $REGION \
        --profile my0p3nvpn
    chmod 600 ~/.aws/my0p3nvpnkeys/$KEY_PAIR_NAME.pem
    exit
fi

echo "Nothing to be done"
