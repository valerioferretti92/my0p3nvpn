#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ];
then
    echo "Enter region as \$1"
    echo "Enter instance profile name as \$2"
    echo "Enter security group name as \$3"
    echo "Enter key pair name as \$4"
    exit
fi

REGION=$1
INSTANCE_PROFILE_NAME=$2
SECURITY_GROUP_NAME=$3
KEY_PAIR_NAME=$4

aws ec2 run-instances \
    --image-id ami-072ba62ae4c03effc \
    --count 1 \
    --instance-type t3.micro \
    --iam-instance-profile Name="$INSTANCE_PROFILE_NAME" \
    --key-name $KEY_PAIR_NAME \
    --security-groups $SECURITY_GROUP_NAME \
    --region $REGION >> instance-details.json
INSTANCE_ID=$(cat instance-details.json | jq -r '.Instances[0].InstanceId')
echo "INSTANCE_ID: $INSTANCE_ID"
rm instance-details.json

aws ec2 describe-instances --instance-ids $INSTANCE_ID >> instance-details.json
INSTANCE_PUBLIC_IP=$(cat instance-details.json | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
echo "INSTANCE_PUBLIC_IP: $INSTANCE_PUBLIC_IP"
rm instance-details.json

echo "The machine is ready to be sshed into!"
echo "Command: ssh ubuntu@$INSTANCE_PUBLIC_IP -i ~/.aws/privatekeys/my0p3nvpn.pem"
