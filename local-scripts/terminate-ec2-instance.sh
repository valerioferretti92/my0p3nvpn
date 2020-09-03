#!/bin/bash
set -e

INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=my0p3nvpn-instance" \
    --filters "Name=instance-state-name,Values=running" \
    --max-items 1 \
    --profile my0p3nvpn | jq -r '.Reservations[0].Instances[0].InstanceId')

if [ -z "$INSTANCE_ID" ] || [ "$INSTANCE_ID" == "null" ];
then
    echo "Nothing to be done"
    exit
fi

if [ -n "$INSTANCE_ID" ];
then
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID --profile my0p3nvpn | cat
else
    echo "Nothing to be done"
fi



