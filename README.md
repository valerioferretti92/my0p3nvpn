# my0p3nvpn

my0p3nvpn is a set of bash scripts that manage and deploy a VPN server on a target machine. The folder **local-scripts** contains a set of scripts to start a new AWS EC2 instance where to deploy the VPN server. The folder **remote-scripts** contains a set of scripts that deploy a VPN server and send the user configuration file to an email address passed as parameter.
A big thanks goes to [Kyle Manna](https://github.com/kylemanna) who provided a Docker container with an OpenVPN server and an EasyRSA PKI CA. Such component is at the core of this project.

## Requirement for running local scripts
This section details the requirements and assumptions that need to hold to successfully run my0p3nvpn local scripts. Since this project is made off bash scripts only, a bash interpreter is mandatory.
**The scripts in local-scripts folder configure and start a new AWS EC2 instance where to deploy our VPN server later on**. For them to run properly, the following conditions must be met:
 - The user must possess a valid [AWS account](https://aws.amazon.com/)
 - The AWS CLI v2 must be installed on the system where local scripts are run. For details about installation follow the [official guidelines](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
 - The AWS profile my0p3nvpn must be present and properly configured. The file ~/.aws/credentials must define such profile as shown in the following code block. Both access key id and secret access key values must be substituted with the ones associated to your AWS account. Such values can be found in the AWS IAM console.

        [my0p3nvpn]
        aws_access_key_id = ####################
        aws_secret_access_key = ****************************************
 - The file ~/.aws/config must contains some additional configuration for the profile created above. Note that the region can be changed here accordingly to user preference. It will not be taken into consideration though, as the target region must always be specified as parameter in local scripts.

        [profile my0p3nvpn]
        region = eu-south-1
        output = json

## Requirement for running remote scripts
This section details the requirements and assumption that need to hold to successfully run my0p3nvpn remote  scripts. Since this project is made off bash scripts only, a **bash interpreter is mandatory**.
The scripts in **remote-scripts** folder configure and deploy an OpenVPN server and an EasyRSA PKI. They allow to automatically configure the environment where they are run, automatically download and install dependencies, register new users, send the user credentials file to an email address, revoke a user certificate. For them to run properly, the following conditions must be met:
 - The remote machine were remote scripts are run must be an Ubuntu machine.
 - When registering a new user, its email address will be sent the user credentials file. The user email must be added to AWS SES and verified beferehand.

## How to run
Both local-scripts and remote-scripts folders contain a script called 'runme.sh'. Such script will trigger all actions necessary to accomplish the aim of both sets of scripts. 'local-scripts/runme.sh' will set up AWS EC2 target machine, the 'remote-scripts/runme.sh' will set up the whole OpenVPN server. To accomplish their objectives, such scripts rely on others, in the same folder that can be used individually to just repeat a specific action without re-executing the whole flow. A use case would be adding a new user when the OpenVPN server is already up and running.

### How to run local scripts to start AWS EC2 instance
The following code block shows how to run the entrypoint script in the folder local-scripts. It will create an AWS role, policy, securty group, access key pair and it will start an Ubuntu 18.04 t3-micro virtual machine.
```
git clone https://github.com/valerioferretti92/my0p3nvpn.git
cd local-scripts
./runme.sh $REGION
```
**Just before terminating, the script will print out the command that needs to be run for ssh-ing into the remote instance**. The SSH key pair is already set up and the private key is already placed in ~/.aws/my0p3nvpnkeys in your local machine.

### How to run remote scripts to deploy and configure an OpenVPN server
The following code block shows how to run the entrypoint script in the folder remote-scripts. It will download and install dependencies, run the OpenVPN server as a docker container through docker-compose, interact with the user the set up the PKI and CA root certificate. It will then register the first user, generate its credentials file, send it to its email address. These scripts must be run on the remote machine, the one where we need to deploy the VPN server. Refer to previous section, to understand how to run local-scripts to start an AWS EC2 instance and ssh into it.
```
git clone https://github.com/valerioferretti92/my0p3nvpn.git
cd remote-scripts
./runme.sh $USER_NAME $USER_EMAIL
```
Once the execution of the script is over, the OpenVPN server will be deployed and it will be listening for UDP connections on port 1194. The user config file will available as attachment in a registration email sent to him. After downloading such file, whatever OpenVPN client may be used to connect to this server. If you are using the openvpn binary as client, you can connect to your brand new OpenVPN server with the following command:
```
sudo openvpn --config /path/to/config/file/received/as/attachment.txt --verb $VERBOSITY_LEVEL
```
