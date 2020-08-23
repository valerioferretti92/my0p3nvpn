#!/bin/bash
set -e

if [ -z "$1" ];
then
    echo "Enter key pair name as \$1"
    exit
fi

KEY_PAIR_NAME=$1

KEY_PAIR_CHECK=$(aws ec2 describe-key-pairs | grep $KEY_PAIR_NAME | cat)
if [ -z "$KEY_PAIR_CHECK" ];
then
    mkdir -p ~/.aws/privatekeys/
    aws ec2 create-key-pair --key-name $KEY_PAIR_NAME --query 'KeyMaterial' --output text > ~/.aws/privatekeys/$KEY_PAIR_NAME.pem
    exit
fi

echo "Nothing to be done"
