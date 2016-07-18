#!/bin/bash

cd /home/fc-web/www
jar -xvf webapp.war
rm -rf /home/fc-web/www/webapp.war
