#!/bin/bash
echo 'Starting'
REGION=`curl http://169.254.169.254/latest/dynamic/instance-identity/document|grep region|awk -F\" '{print $4}'`
echo $REGION
echo 'Configuring region'
aws configure set region $REGION

#aws Getting 
echo 'Getting CID'
cid=`aws ssm get-parameter --name AgentActivationKey --query 'Parameter.Value' --output text`

echo $cid

echo 'Getting S3 Bucket Location'
agentloc=`aws ssm get-parameter --name AgentInstallLocation --query 'Parameter.Value' --output text`

echo $agentloc

aws s3 cp s3://$agentloc/falcon-sensor-4.11.0-5609.amzn1.x86_64.rpm /tmp/falcon-sensor-4.11.0-5609.amzn1.x86_64.rpm

yum install /tmp/falcon-sensor-4.11.0-5609.amzn1.x86_64.rpm -y
/opt/CrowdStrike/falconctl -s --cid=$cid
service falcon-sensor start

# Add command to call installer.  For example "yum install .\ExamplePackage.rpm"