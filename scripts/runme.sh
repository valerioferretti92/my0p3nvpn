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

ACCOUNT=$1
if [-z "$ACCOUNT" ]
then
    echo "Enter username of the account to be registered as \$1"
    exit
fi

echo "[runme.sh]: Installing and configure project dependencies"
sudo apt -y update
sudo apt -y upgrade

sudo apt -y install docker.io
sudo systemctl start docker

DOCKER_COMPOSE_FILE=/usr/local/bin/docker-compose
if [ ! -f "$DOCKER_COMPOSE_FILE" ]
then
    sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" \
            -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi

echo "[runme.sh]: Configuring openvpn server"
./configure.sh $(hostname)

echo "[runme.sh]: Registering user account"
./register-account.sh $ACCOUNT

echo "[runme.sh]: Starting openvpn container"
./start.sh
