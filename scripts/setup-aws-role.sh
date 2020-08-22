#!/bin/bash

set -e

ROLE=$(aws iam list-roles | grep my0p3nvpn-role | cat)
INSTANCE_PROFILE=$(aws iam list-instance-profiles | grep my0p3nvpn-instance-profile | cat)

if [ -z "$ROLE" ] && [ -z "$INSTANCE_PROFILE" ];
then
    echo "Creating both AWS role and instance profile"
    aws iam create-role \
        --role-name my0p3nvpn-role \
        --assume-role-policy-document file://../resources/my0p3nvpn-trust-policy.json
    aws iam put-role-policy \
        --role-name my0p3nvpn-role --policy-name my0p3nvpn-policy \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json
    aws iam create-instance-profile \
        --instance-profile-name my0p3nvpn-instance-profile
    aws iam add-role-to-instance-profile \
        --instance-profile-name my0p3nvpn-instance-profile \
        --role-name my0p3nvpn-role
    exit
fi

if [ -z "$ROLE" ] && [ -n "$INSTANCE_PROFILE" ];
then
    echo "Creating AWS role"
    aws iam create-role \
        --role-name my0p3nvpn-role \
        --assume-role-policy-document file://../resources/my0p3nvpn-trust-policy.json
    aws iam put-role-policy \
        --role-name my0p3nvpn-role --policy-name my0p3nvpn-policy \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json
    aws iam add-role-to-instance-profile \
        --instance-profile-name my0p3nvpn-instance-profile \
        --role-name my0p3nvpn-role
    exit
fi

if [ -n "$ROLE" ] && [ -z "$INSTANCE_PROFILE" ];
then
    echo "Creating AWS instance profile"
    aws iam put-role-policy \
        --role-name my0p3nvpn-role --policy-name my0p3nvpn-policy \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json
    aws iam create-instance-profile \
        --instance-profile-name my0p3nvpn-instance-profile
    aws iam add-role-to-instance-profile \
        --instance-profile-name my0p3nvpn-instance-profile \
        --role-name my0p3nvpn-role
    exit
fi

echo "Nothing to be done"
