#!/bin/bash
set -e

sudo apt update
mkdir -p /tmp/ssm
cd /tmp/ssm
# install ssm
wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

sudo dpkg -i amazon-ssm-agent.deb

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent



#install nginx
sudo apt install nginx -y
sudo systemctl restart nginx


# install java
sudo apt install fontconfig openjdk-21-jre -y

# install jenkins 
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt install jenkins -y

# check passwd for jenkins master
sudo cat /var/lib/jenkins/secrets/initialAdminPassword