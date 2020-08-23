#!/bin/bash
set -e

INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:name,Values=my0p3nvpn-instance" | jq -r '.Reservations[0].Instances[0].InstanceId')
if [ -n "$INSTANCE_ID" ];
then
    aws ec2 terminate-instances --instance-ids $INSTANCE_ID | cat
else
    echo "Nothing to be done"
fi



