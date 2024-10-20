#!/bin/bash
component=$1
environment=$2 #should not use env here, env is reserved in linux
yum install python3.11-devel python3.11-pip -y
pip3.11 install ansible botocore boto3
ansible-pull -u https://github.com/PraveenKumar8919/ansible-roles-tf.git -e component=$component -e env=$environment main.yaml