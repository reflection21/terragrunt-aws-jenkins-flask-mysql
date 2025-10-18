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
sudo apt install fontconfig openjdk-21-jre -y
sudo groupadd jenkins && sudo useradd -g jenkins jenkins
sudo mkdir -p /home/jenkins/worker && sudo chmod -R 755 /home/jenkins/worker && sudo chown jenkins:jenkins /home/jenkins/worker


# install agent
# sudo curl -sO http://<private-ip-jenkins-master>/jnlpJars/agent.jar

# run agent
# sudo java -jar agent.jar -url http://10.10.1.72:8080/ \
# -secret 13063178cb7df879e1a308ff231b5ac88ec3433e0962b623c1b94cb2bd0db404 \
# -name worker1 -webSocket -workDir "/home/jenkins/worker"

# run agent if dir /tmp have not much ram
# sudo java -Djava.io.tmpdir=/home/jenkins/worker/remote -jar agent.jar -url http://10.10.1.72:8080/ \
# -secret 13063178cb7df879e1a308ff231b5ac88ec3433e0962b623c1b94cb2bd0db404 \
# -name worker1 -webSocket -workDir "/home/jenkins/worker/"