#!/bin/bash -eux
set -o pipefail

ec2='aws --profile 'aws+dev' ec2 --region eu-west-1'

iid=$($ec2 describe-instances --filters Name=tag:Name,Values=dl_staging_kuettel | jq '.Reservations[0].Instances[0].InstanceId' -r)
$ec2 start-instances --instance-ids $iid

ip=null
until [ $ip != null ]; do
	sleep 3
	ip=$($ec2 describe-instances --instance-ids $iid | jq '.Reservations[0].Instances[0].PublicIpAddress' -r)
done

until ssh -o ConnectTimeout=5 -L 5901:localhost:5901 -R 2222:localhost:22 $ip; do
	sleep 1
done
