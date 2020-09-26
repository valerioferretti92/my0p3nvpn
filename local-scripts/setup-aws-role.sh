#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ];
then
    echo "Enter region as \$1, role name as \$2, policy name as \$3 and instance profile name as \$4"
    exit
fi

REGION=$1
ROLE_NAME=$2
POLICY_NAME=$3
INSTANCE_PROFILE_NAME=$4

ROLE_CHECK=$(aws iam list-roles --region $REGION --profile my0p3nvpn | grep $ROLE_NAME | cat)
INSTANCE_PROFILE_CHECK=$(aws iam list-instance-profiles --region $REGION --profile my0p3nvpn | grep $INSTANCE_PROFILE_NAME | cat)

if [ -z "$ROLE_CHECK" ] && [ -z "$INSTANCE_PROFILE_CHECK" ];
then
    echo "Creating both AWS role and instance profile"
    aws iam create-role \
        --role-name $ROLE_NAME \
        --assume-role-policy-document file://../resources/my0p3nvpn-trust-policy.json \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws iam put-role-policy \
        --role-name $ROLE_NAME --policy-name $POLICY_NAME \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws iam create-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws iam add-role-to-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --role-name $ROLE_NAME \
        --region $REGION \
        --profile my0p3nvpn | cat
    exit
fi

if [ -z "$ROLE_CHECK" ] && [ -n "$INSTANCE_PROFILE_CHECK" ];
then
    echo "Creating AWS role"
    aws iam create-role \
        --role-name $ROLE_NAME \
        --assume-role-policy-document file://../resources/my0p3nvpn-trust-policy.json \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws iam put-role-policy \
        --role-name $ROLE_NAME --policy-name $POLICY_NAME \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws iam add-role-to-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --role-name $ROLE_NAME \
        --region $REGION \
        --profile my0p3nvpn | cat
    exit
fi

if [ -n "$ROLE_CHECK" ] && [ -z "$INSTANCE_PROFILE_CHECK" ];
then
    echo "Creating AWS instance profile"
    aws iam put-role-policy \
        --role-name $ROLE_NAME --policy-name $POLICY_NAME \
        --policy-document file://../resources/my0p3nvpn-permission-policy.json \
        --region $REGION \
        --profile my0p3nvpn | cat
    aws iam create-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --region $REGION \
        --profile my0p3nvpn| cat
    aws iam add-role-to-instance-profile \
        --instance-profile-name $INSTANCE_PROFILE_NAME \
        --role-name $ROLE_NAME \
        --region $REGION \
        --profile my0p3nvpn | cat
    exit
fi

echo "Nothing to be done"
