#!/bin/bash

set -e

main() {
    date
    countdown

    #check adb server running
    ps aux |  grep '^ro[o]t.*adb .*server' 
    echo starting adb server
    if [ $? != 0 ]; then 
	echo no adb server running;
	sudo adb kill-server
	sudo adb start-server
    else
	echo adb server already running;
    fi

    #check if devices show up
    echo searching for devices
    adb devices | grep -v '^List' | grep -v '^$'
    NUMDEVICES=$(adb devices | grep -v '^List' | grep -v '^$' | wc -l )
    if [ "$NUMDEVICES" == "0" ]; then
	echo "No Devices Found"
	echo "Restarting Server"
	sudo adb kill-server
	sudo adb start-server
	exit 1
    else
	echo "$NUMDEVICES Devices Found"
    fi

    adb wait-for-device

    cd /opt/reverse-tether

    echo kill vpn app on android in case it is already running:
    adb shell am force-stop com.google.android.vpntether 

    countdown

    echo setting up tunnel
    ./run.sh setup 2>&1

    countdown

    echo starting tunnel
    ./run.sh run

    countdown

    #echo starting tap to enable
    #adb shell am start -a android.intent.action.VIEW -d https://coral.nanofab.utah.edu/lab/tap_to_enable
    #countdown
}

countdown() {
    SLEEPTIME=10
    while [ $SLEEPTIME != 0 ]; do
        echo sleeping $SLEEPTIME seconds
        sleep 1
        SLEEPTIME=$[ $SLEEPTIME - 1 ]
    done
}

main

