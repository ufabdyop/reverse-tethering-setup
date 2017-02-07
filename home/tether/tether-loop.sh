#!/bin/bash

cd /opt/reverse-tether
while true; do
        echo sleeping 10 seconds
        sleep 10
        sudo /opt/reverse-tether/upstart.sh
done
