# Set up AWS Role
# Set up AWS security group
# Instanciate an EC2 virtual machine in a given region and returns public IP address

#!/bin/bash
set -e

if [ -z "$1" ];
then
    echo "Enter EC2 region as \$1"
    exit
fi

ROLE_NAME=my0p3nvpn-role
POLICY_NAME=my0p3nvpn-policy
INSTANCE_PROFILE_NAME=my0p3nvpn-instance-profile
SECURITY_GROUP_NAME=my0p3nvpn-security-group
KEY_PAIR_NAME=my0p3nvpn-key

REGION=$1

BLUE='\033[0;34m'
BOLD='\033[1m'
NONE='\033[00m'

print_section_title() {
    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        echo -e "${BLUE}${BOLD}[runme.sh]: $1${NONE}"
    elif [[ "$OSTYPE" == "darwin"* ]];
    then
        echo "${BLUE}${BOLD}[runme.sh]: $1${NONE}"
    fi
}

print_subsection_title() {
    if [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        echo -e "${BLUE}${BOLD}[runme.sh]:${NONE} ${BOLD}$1${NONE}"
    elif [[ "$OSTYPE" == "darwin"* ]];
    then
        echo "${BLUE}${BOLD}[runme.sh]:${NONE} ${BOLD}$1${NONE}"
    fi
}

print_section_title "Setting up AWS environment"
print_subsection_title "Setting up AWS Roles"
./setup-aws-role.sh $ROLE_NAME $POLICY_NAME $INSTANCE_PROFILE_NAME

print_subsection_title "Setting up AWS Security group"
./setup-aws-security-group.sh $SECURITY_GROUP_NAME

print_section_title "Setting up key pair"
./setup-aws-key-pair.sh $KEY_PAIR_NAME

print_section_title "Instanciating EC2 virtual machine"
./start-ec2-instance.sh $REGION $INSTANCE_PROFILE_NAME $SECURITY_GROUP_NAME $KEY_PAIR_NAME
