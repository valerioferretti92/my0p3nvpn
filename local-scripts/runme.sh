# Set up AWS Role
# Set up AWS security group
# Instanciate an EC2 virtual machine in a given region and returns public IP address

#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ];
then
    echo "Enter EC2 region as \$1 and key pair name as \$2"
    exit
fi

ROLE_NAME=my0p3nvpn-role
POLICY_NAME=my0p3nvpn-policy
INSTANCE_PROFILE_NAME=my0p3nvpn-instance-profile
SECURITY_GROUP_NAME=my0p3nvpn-security-group

REGION=$1
KEY_PAIR_NAME=$2

BLUE='\033[0;34m'
BOLD='\033[1m'
NONE='\033[00m'

print_section_title() {
    echo -e "${BLUE}${BOLD}[runme.sh]: $1${NONE}"
}

print_subsection_title() {
    echo -e "${BLUE}${BOLD}[runme.sh]:${NONE} ${BOLD}$1${NONE}"
}

print_section_title "Setting up AWS environment"
print_subsection_title "Setting up AWS Roles"
./setup-aws-role.sh $ROLE_NAME $POLICY_NAME $INSTANCE_PROFILE_NAME

print_subsection_title "Setting AWS Security group"
./setup-aws-security-group.sh $SECURITY_GROUP_NAME

print_section_title "Instanciating EC2 virtual machine"
./start-ec2-instance.sh $REGION $INSTANCE_PROFILE_NAME $SECURITY_GROUP_NAME $KEY_PAIR_NAME
