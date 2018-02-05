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

function requirements(){
	
	echo ' Checking requirements...'

	if command_exists "mvn"; then
		echo "maven already installed"
	else
		echo "Installing maven..."
		echo "sudo apt install -y maven"
		sudo apt install -y maven
	fi
}

function compile(){
	module=$1
	#compile module
	echo "

	Compiling module: $module

	"
	cd $base && cd mods/$1 && mvn clean install && cd $base
}

function main(){

	echo " ########################################## "
	echo "        Sync latest official plugins        "
	echo " ########################################## "

	export base=$(pwd)

	#no dependencies
	compile logger
	compile sdk

	compile axmlprinter
	compile rulengine
	compile ml

	compile vfs 

	#depends on vfs
	compile memapktool

	#depends on axmlprinter, rulengine, ml, memapktool
	compile core

	##depends on module core, sdk, logger
	compile plugins

	echo " Building done "
}

set -e
requirements
main