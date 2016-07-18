#!/bin/bash

webapp_pid() {
	echo `ps aux | grep "fc-web/apps/tomcat" | grep -v grep  | awk '{ print $2 }'`
}

WEBAPP_PID=$(webapp_pid)

if [ ! -z "$WEBAPP_PID" -a "$WEBAPP_PID" != "" ]; then
        cd /home/fc-web/artifacts
        rm -rf webapp.war

        if [ -L "current" ];then
                if [ -L "previous" ];then
                        unlink previous
                fi
                ln -s `readlink current` previous
                unlink current
                ln -s `ls -t | head -2 | tail -1` current
        else
                ln -s `ls -t | head -1` current
        fi

	if [ -L "current" ];then
                if [ -L "previous" ];then
                        find . ! -name `readlink current` ! -name `readlink previous` -type f -delete
                fi
        fi
fi
