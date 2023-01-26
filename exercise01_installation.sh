#/bin/sh!

## Installation of Docker --- usually not necessary / already done
#apt update
#apt-get remove docker docker-engine docker.io containerd runc
#sudo apt install docker.io -y
#curl -fsSL https://get.docker.com -o get-docker.sh
#sh ./get-docker.sh
#rm get-docker.sh

## Add Docker to autostart --- usually not necessary / already done
#sudo visudo
#$USER ALL=(ALL) NOPASSWD: /usr/bin/dockerd

#echo '# Start Docker daemon automatically when logging in if not running.' >> ~/.bashrc
#echo 'RUNNING=`ps aux | grep dockerd | grep -v grep`' >> ~/.bashrc
#echo 'if [ -z "$RUNNING" ]; then' >> ~/.bashrc
#echo '    sudo dockerd > /dev/null 2>&1 &' >> ~/.bashrc
#echo '    disown' >> ~/.bashrc
#echo 'fi' >> ~/.bashrc

## Add current user to docker-Group --- usually not necessary / already done
#usermod -a -G docker $USER

## Install Azure CLI --- usually not necessary / already done
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Run the container "hello-world" (actually: create and run a container based on the image "hello-world")
docker run hello-world
docker ps -a
