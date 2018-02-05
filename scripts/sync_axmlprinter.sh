#!/bin/bash

#set current location at this script location
SCRIPT_PATH="`dirname \"$0\"`"
#now script is located at ./scripts/ folder. Move to parent
cd $SCRIPT_PATH/..

source ./scripts/colors.sh

title "Downloading latest version of axmlprinter"
cloneFolder=rednaga_axmlprinter
targetFolder=axmlprinter
if [[ ! -d $cloneFolder ]]; then
	git clone https://github.com/rednaga/axmlprinter $cloneFolder
fi
base=$(pwd)
cd $cloneFolder

subtitle "Deleting old files..."

oldFilesFolder="$base/mods/$targetFolder/"
if [[ -d $oldFilesFolder ]]; then
	log "rm -rf $oldFilesFolder"
	rm -rf $oldFilesFolder
else
	mkdir -p $oldFilesFolder
fi

subtitle "Syncing files..."

if [[ ! -d $base/mods/$targetFolder/src/main/ ]]; then
	mkdir -p $base/mods/$targetFolder/src/main/
fi
cmd="cp -ra $base/$cloneFolder/src/main/. $base/mods/$targetFolder/src/main/"
log $cmd
$cmd

subtitle "	Syncing tests..."
if [[ ! -d $base/mods/$targetFolder/src/test/ ]]; then
	mkdir -p $base/mods/$targetFolder/src/test/
fi
cmd="cp -ra $base/$cloneFolder/src/test/. $base/mods/$targetFolder/src/test/"
log $cmd
$cmd

#remove temp files
subtitle "removing temp files..."
log "rm -rf $base/$cloneFolder"
rm -rf $base/$cloneFolder

cd  $base/mods/$targetFolder
git checkout axmlprinter.iml pom.xml
cd $base