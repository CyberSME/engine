#!/bin/bash

#set current location at this script location
SCRIPT_PATH="`dirname \"$0\"`"
#now script is located at ./scripts/ folder. Move to parent
cd $SCRIPT_PATH/..

source ./scripts/colors.sh

title "Downloading latest version of apktool"
if [[ ! -d Apktool ]]; then
	git clone https://github.com/iBotPeaches/Apktool
fi
base=$(pwd)
cd Apktool

subtitle "Syncing files..."

subtitle "	Syncing util..."
log "cp -ra $base'/Apktool/brut.j.util/src/main/java/.' $base'/mods/memapktool/src/main/java/' "
cp -ra $base'/Apktool/brut.j.util/src/main/java/.' $base'/mods/memapktool/src/main/java/' 

subtitle "	Syncing dir..."
log "cp -ra $base'/Apktool/brut.j.dir/src/main/java/.' $base'/mods/memapktool/src/main/java/' "
cp -ra $base'/Apktool/brut.j.dir/src/main/java/.' $base'/mods/memapktool/src/main/java/' 

subtitle "	Syncing common..."
log "cp -ra $base'/Apktool/brut.j.common/src/main/java/.' $base'/mods/memapktool/src/main/java/' "
cp -ra $base'/Apktool/brut.j.common/src/main/java/.' $base'/mods/memapktool/src/main/java/' 

subtitle "	Syncing apktool-lib..."
log "cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/main/java/.' $base'/mods/memapktool/src/main/java'"
cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/main/java/.' $base'/mods/memapktool/src/main/java/' 

subtitle "	Syncing apktool-lib resources..."
log "cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/main/resources/.' $base'/mods/memapktool/src/main/resources'"
cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/main/resources/.' $base'/mods/memapktool/src/main/resources'

subtitle "	Syncing apktool-lib test resources..."
log "cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/test/resources/.' $base'/mods/memapktool/src/test/resources'"
cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/test/resources/.' $base'/mods/memapktool/src/test/resources'

subtitle "	Syncing apktool-lib test files..."
log "cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/test/java/.' $base'/mods/memapktool/src/test/java'"
cp -ra $base'/Apktool/brut.apktool/apktool-lib/src/test/resources/.' $base'/mods/memapktool/src/main/resources'

subtitle "	Syncing apktool-cli..."
cp -ra $base'/Apktool/brut.apktool/apktool-cli/src/main/java/brut/apktool/.' $base'/mods/memapktool/src/main/java/brut/apktool'

#remove temp files
subtitle "removing temp files..."
log "rm -rf $base/Apktool"
rm -rf $base/Apktool