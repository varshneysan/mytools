#!/bin/bash

elb=$(awk '/^\[global\]/{f=1} f==1&&/^elb_name/{print $3;exit}' "/etc/elb-info")
id=`wget -q -O - http://instance-data/latest/meta-data/instance-id`
aws elb deregister-instances-from-load-balancer --load-balancer-name $elb --instances $id --region ap-southeast-1
