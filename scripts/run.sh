#!/bin/bash

#set current location at this script location
SCRIPT_PATH="`dirname \"$0\"`"
#now script is located at ./scripts/ folder. Move to parent
cd $SCRIPT_PATH/..

base=$(pwd)

cd target

jarname=$(ls *jar)

echo "Running: " $jarname
java -jar $jarname