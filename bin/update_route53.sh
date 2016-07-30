#!/bin/bash -xeu
set -o pipefail
aws --profile guacamole-dev route53 change-resource-record-sets --hosted-zone-id /hostedzone/Z33G1YV62JFP31 --change-batch '{"Changes": [{"Action": "UPSERT", "ResourceRecordSet": { "Name": "kuettel.dev.vuforia.com.", "Type": "A", "TTL": 300, "ResourceRecords": [{ "Value": "'$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)'" }]}}]}'
