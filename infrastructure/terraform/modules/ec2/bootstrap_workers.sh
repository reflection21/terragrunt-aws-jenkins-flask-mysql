#!/bin/bash
set -e

sudo apt update
mkdir -p /tmp/ssm
cd /tmp/ssm

wget https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/debian_amd64/amazon-ssm-agent.deb

sudo dpkg -i amazon-ssm-agent.deb

sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent


# install java
sudo apt install fontconfig openjdk-21-jre
sudo groupadd jenkins && sudo useradd -g jenkins jenkins
sudo mkdir -p /home/jenkins/worker && sudo chmod -R 755 /home/jenkins/worker && sudo chown jenkins:jenkins /home/jenkins/worker