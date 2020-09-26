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
case $REGION in
    "eu-south-1")
        AMI_ID=ami-06a72c0e11b785451;;
    "us-east-1")
        AMI_ID=ami-0817d428a6fb68645;;
    *)
        echo "[ERROR]: It was not possible to get an AMI ID for launching your instance. Check region / AMI DI association"
        exit;;
esac

aws ec2 run-instances \
    --image-id $AMI_ID \
    --count 1 \
    --instance-type t3.micro \
    --iam-instance-profile Name="$INSTANCE_PROFILE_NAME" \
    --key-name $KEY_PAIR_NAME \
    --security-groups $SECURITY_GROUP_NAME \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=my0p3nvpn-instance}]' \
    --region $REGION \
    --profile my0p3nvpn >> instance-details.json
INSTANCE_ID=$(cat instance-details.json | jq -r '.Instances[0].InstanceId')
echo "INSTANCE_ID: $INSTANCE_ID"
rm instance-details.json

aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --region $REGION \
    --profile my0p3nvpn >> instance-details.json
INSTANCE_PUBLIC_IP=$(cat instance-details.json | jq -r '.Reservations[0].Instances[0].PublicIpAddress')
echo "INSTANCE_PUBLIC_IP: $INSTANCE_PUBLIC_IP"
rm instance-details.json

rm -f ~/.ssh/known_hosts
echo "The machine is ready to be sshed into!"
echo "Command: ssh ubuntu@$INSTANCE_PUBLIC_IP -i ~/.aws/my0p3nvpnkeys/$KEY_PAIR_NAME.pem"
echo "Clone repo: git clone https://github.com/valerioferretti92/my0p3nvpn.git"

