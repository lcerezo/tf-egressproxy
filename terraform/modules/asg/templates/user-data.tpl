#!/bin/bash

export environment=${environment}
result=1
while [ $result -ne 0 ]; do
  if [ $environment == 'prod' ] || [ $environment == 'uat' ];
      then
       sudo wget http://lucholab0-web.s3-website-us-east-1.amazonaws.com/repo/prod/yum.repo -O /etc/yum.repos.d/lucholab0-web.repo
       result=$?
      else
       sudo wget http://lucholab0-web.s3-website-us-east-1.amazonaws.com/repo/dev/yum.repo -O /etc/yum.repos.d/lucholab0-web.repo
       result=$?
  fi
done
logger "installing proxy playbook version ${squidproxy-release}"
yum -y install squidproxy-deployment
for n in `seq 1 3`; do /usr/bin/ansible-playbook -e @/opt/lucholab0/squidproxy-deployment/current/ansible/aws.${environment}.squid.dict.json --connection=local -i localhost, /opt/lucholab0/squidproxy-deployment/current/ansible/ec2-local.site.yml -b;sleep 10;done;