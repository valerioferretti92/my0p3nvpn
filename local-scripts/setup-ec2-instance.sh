#!/bin/bash

set -e

KEY_PAIR_NAME=my0p3nvpn
ROLE=my0p3nvpn-role
INSTANCE_PROFILE=my0p3nvpn-instance-profile

ROLE_CHECK=$(aws iam list-roles | grep $ROLE | cat)
INSTANCE_PROFILE_CHECK=$(aws iam list-instance-profiles | grep $INSTANCE_PROFILE | cat)

if [ -z "$ROLE_CHECK" ] && [ -z "$INSTANCE_PROFILE_CHECK" ];
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

if [ -z "$ROLE_CHECK" ] && [ -n "$INSTANCE_PROFILE_CHECK" ];
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

if [ -n "$ROLE_CHECK" ] && [ -z "$INSTANCE_PROFILE_CHECK" ];
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