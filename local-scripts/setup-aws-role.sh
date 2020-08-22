#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ];
then
    echo "Enter role name as \$1, policy name as \$2 and instance profile name as \$3"
    exit
fi

ROLE_NAME=$1
POLICY_NAME=$2
INSTANCE_PROFILE_NAME=$3

ROLE_CHECK=$(aws iam list-roles | grep $ROLE | cat)
INSTANCE_PROFILE_CHECK=$(aws iam list-instance-profiles | grep $INSTANCE_PROFILE | cat)

if [ -z "$ROLE_CHECK" ] && [ -z "$INSTANCE_PROFILE_CHECK" ];
then
    echo "Creating both AWS role and instance profile"
    aws iam create-role \
        --role-name $ROLE_NAME \
        --assume-role-policy-document file://../resources/my0p3nvpn-trust-policy.json
    aws iam put-role-policy \
        --role-name $ROLE_NAME --policy-name $POLICY_NAME \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json
    aws iam create-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME
    aws iam add-role-to-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --role-name $ROLE_NAME
    exit
fi

if [ -z "$ROLE_CHECK" ] && [ -n "$INSTANCE_PROFILE_CHECK" ];
then
    echo "Creating AWS role"
    aws iam create-role \
        --role-name $ROLE_NAME \
        --assume-role-policy-document file://../resources/my0p3nvpn-trust-policy.json
    aws iam put-role-policy \
        --role-name $ROLE_NAME --policy-name $POLICY_NAME \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json
    aws iam add-role-to-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --role-name $ROLE_NAME
    exit
fi

if [ -n "$ROLE_CHECK" ] && [ -z "$INSTANCE_PROFILE_CHECK" ];
then
    echo "Creating AWS instance profile"
    aws iam put-role-policy \
        --role-name $ROLE_NAME --policy-name $POLICY_NAME \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json
    aws iam create-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME
    aws iam add-role-to-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --role-name $ROLE_NAME
    exit
fi

echo "Nothing to be done"
