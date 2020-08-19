# Installs and configures project dependencies
#  - docker
#  - docker-compose
#  - add default user to docker group
# Configures openvpn server
# Adds user account
# Sends credential file by email
# Starts openvpn container
# $1: domain name / IP address of openvpn server
# $2: username of the account to be registered

#!/bin/bash

BLUE='\033[0;34m'
BOLD='\033[1m'
NONE='\033[00m'

ACCOUNT=$1
if [ -z "$ACCOUNT" ]
then
    echo "Enter username of the account to be registered as \$1"
    exit
fi

echo -e "${BLUE}${BOLD}[runme.sh]: Installing and configure project dependencies${NONE}"
echo -e "${BLUE}${BOLD}[runme.sh]:${NONE} ${BLUE}Updating and upgrading system${NONE}"
sudo apt -y update
sudo apt -y upgrade

echo -e "${BLUE}${BOLD}[runme.sh]:${NONE} ${BLUE}Installing docker.io${NONE}"
sudo apt -y install docker.io
sudo systemctl start docker

echo -e "${BLUE}${BOLD}[runme.sh]:${NONE} ${BLUE}Installing docker-compose${NONE}"
DOCKER_COMPOSE_FILE=/usr/local/bin/docker-compose
if [ ! -f "$DOCKER_COMPOSE_FILE" ]
then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo -e "${BLUE}${BOLD}[runme.sh]: Configuring openvpn server${NONE}"
./configure.sh $(hostname)

echo -e "${BLUE}${BOLD}[runme.sh]: Registering user account${NONE}"
./register-account.sh $ACCOUNT

echo -e "${BLUE}${BOLD}[runme.sh]: Starting openvpn container${NONE}"
./start.sh
