#!/bin/bash
#
# If we want to pull images from a registry using TLS and our system don't trust that entity, we can do the following

SERVER_NAME="my.docker.registry"
SERVER_PORT=443

USERNAME="myusername"
PASSWORD="mypassword"

# Fetch the public key and store it in pem format in some file on your system
echo -n | openssl s_client -servername $SERVER_NAME -showcerts -connect ${SERVER_NAME}:${SERVER_PORT} | openssl x509 -outform pem > ./${SERVER_NAME}.crt

# Create the folder /etc/docker/certs.d/my.docker.registry
sudo mkdir --parent /etc/docker/certs.d/${SERVER_NAME}

# Copy the public key to the folder
sudo mv ./${SERVER_NAME}.crt /etc/docker/certs.d/${SERVER_NAME}/client.crt

# Login to the server using docker client
echo $PASSWORD | docker login --username ${USERNAME} --password-stdin ${SERVER_NAME}

###########################################################
## Additional: If you need to authentication to Jenkins, ##
## copy the $HOME/.docker/config.json file to            ## 
## /var/lib/jenkins of the home directory of your desire ##
###########################################################
sudo cp -r $HOME/.docker /var/lib/jenkins
sudo chown -R jenkins:jenkins /var/lib/jenkins/.docker

