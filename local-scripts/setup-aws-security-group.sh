#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ];
then
    echo "Enter region as \$1, security group name as \$2"
fi

REGION=$1
SECURITY_GROUP_NAME=$2

SECURITY_GROUP_NAME_CHECK=$(aws ec2 describe-security-groups --region $REGION --profile my0p3nvpn | grep "my0p3nvpn-security-group"|cat)
if [ -z "$SECURITY_GROUP_NAME_CHECK" ];
then
    aws ec2 create-security-group \
        --group-name $SECURITY_GROUP_NAME \
        --description "SSH and UDP on port 1194 from anywhere" \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws ec2 authorize-security-group-ingress \
        --group-name $SECURITY_GROUP_NAME \
        --protocol tcp --port 22 \
        --cidr 0.0.0.0/0 \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws ec2 authorize-security-group-ingress \
        --group-name $SECURITY_GROUP_NAME \
        --protocol udp \
        --port 1194 \
        --cidr 0.0.0.0/0 \
        --region $REGION \
        --profile my0p3nvpn | cat
else
    echo "Nothing to be done"
fi
