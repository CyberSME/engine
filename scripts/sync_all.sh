#!/bin/bash

#set current location at this script location
SCRIPT_PATH="`dirname \"$0\"`"
#now script is located at ./scripts/ folder. Move to parent
cd $SCRIPT_PATH/..

#import color logs functions
source ./scripts/colors.sh

title "Running all sync scripts..."

subtitle "Syncing apktool..."
bash ./sync_apktool.sh

subtitle "Syncing rednaga.axml..."
bash ./sync_axmlprinter.sh

subtitle "Syncing simplemagic..."
bash ./sync_simplemagic.sh

subtitle "Syncing droidefense plugins..."
bash ./sync_plugins.sh