#!/bin/bash

function check_monit_status {
        service=`sudo monit summary | grep "pending"`
        while [[ $service == *"webapp"* ]]
        do
	sleep 10
        service=`sudo monit summary | grep "pending"`
        done
}

function tomcat_Initialization {

MAX_MONITORING_TIME=300
START=$(date +%s)
while [ TRUE ]
do
   sleep 30
   curl -s localhost:8080 --connect-timeout $MAX_MONITORING_TIME | grep -q "About Us" && END=$(date +%s) && DIFF=$(( $END - $START )) && echo "Total time take in tomcat Initialization : $DIFF secs" && break || echo "Timeout : Tomcat Initialization failed"

done

}

check_monit_status
sudo /usr/bin/monit start webapp
if [ $? -ne 0 ]; then
    echo "Starting tomcat failed"
    exit 1
fi
check_monit_status

#sudo /etc/init.d/fc-web-tomcat start

echo "Waiting for tomcat to initialize..."
tomcat_Initialization


