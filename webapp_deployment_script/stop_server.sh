#!/bin/bash

function check_monit_status {
        service=`sudo monit summary | grep "pending"`
        while [[ $service == *"webapp"* ]]
        do
	sleep 10
        service=`sudo monit summary | grep "pending"`
        done
}

check_monit_status
echo "Shutting down Tomcat"
sudo /usr/bin/monit stop webapp
if [ $? -ne 0 ]; then
    echo "Stopping tomcat failed"
    exit 1
fi

check_monit_status

sudo /etc/init.d/fc-web-tomcat stop
if [ $? -ne 0 ]; then
    echo "Stopping tomcat failed"
    exit 1
fi
echo "Checking if a tomcat process exists"
NUM_TOMCAT_PROC=`ps -ef | grep  org.apache.catalina.startup.Bootstrap | grep 'fc-web' | grep -v "grep" | wc -l`
if [ $NUM_TOMCAT_PROC -eq 0 ]; then
  echo "No tomcat process. Good!"
else
#  sudo /etc/init.d/fc-web-tomcat stop
  echo "Tomcat process still exists. Exiting"
  exit 1
fi

