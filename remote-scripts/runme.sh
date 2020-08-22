# Installs and configures project dependencies
#  - docker
#  - docker-compose
#  - install AWS CLI
#  - add default user to docker group
# Configures openvpn server
# Adds user account
# Sends credential file by email
# Starts openvpn container
# $1: domain name / IP address of openvpn server
# $2: username of the account to be registered

#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Enter new user's username and email as \$1 and \$2"
    exit
fi

ACCOUNT=$1
EMAIL=$2

BLUE='\033[0;34m'
BOLD='\033[1m'
NONE='\033[00m'

print_section_title() {
    echo -e "${BLUE}${BOLD}[runme.sh]: $1${NONE}"
}

print_subsection_title() {
    echo -e "${BLUE}${BOLD}[runme.sh]:${NONE} ${BOLD}$1${NONE}"
}

print_section_title "Installing and configure project dependencies"
print_subsection_title "Updating and upgrading system"
sudo apt -y update
sudo apt -y upgrade

print_subsection_title "Installing docker.io"
sudo apt -y install docker.io
sudo systemctl start docker

print_subsection_title "Installing docker-compose"
DOCKER_COMPOSE_FILE=/usr/local/bin/docker-compose
if [ ! -f "$DOCKER_COMPOSE_FILE" ]
then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

print_subsection_title "Installing AWS CLI"
sudo apt -y install unzip
AWS_CLI_FILE=/usr/local/bin/aws
if [ ! -f "$AWS_CLI_FILE" ]
then
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
    unzip -q /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
fi

print_section_title "Configuring openvpn server"
./configure.sh $(hostname)

print_section_title "Registering user account"
./register-account.sh $ACCOUNT
print_subsection_title "Sending credential file by email"
./send-email.sh $EMAIL ../user-profiles/$ACCOUNT.ovpn

print_section_title "Starting openvpn container"
./start.sh
