#!/bin/bash

#set current location at this script location
SCRIPT_PATH="`dirname \"$0\"`"
#now script is located at ./scripts/ folder. Move to parent
cd $SCRIPT_PATH/..

source ./scripts/colors.sh

function command_exists() {
  #this should be a very portable way of checking if something is on the path
  #usage: "if command_exists foo; then echo it exists; fi"
  type "$1" &> /dev/null
}

function prerequirements(){
	
	log ' Installing prerequisites...'

	if command_exists "mvn"; then
		ok "maven already installed"
	else
		log "Installing maven..."
		log "sudo apt install -y maven"
		sudo apt install -y maven
	fi
}

function clean(){
	log ' Cleaning current workdir...'
	rm -rf log reports unpack target out config
}

function main(){

	log ' Building droidefense from current version'

	log "mvn clean package"
	mvn package -T4

	ok " Building done "
}

set -e

prerequirements
clean
main
