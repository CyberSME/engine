#!/bin/bash

#set current location at this script location
SCRIPT_PATH="`dirname \"$0\"`"
#now script is located at ./scripts/ folder. Move to parent
cd $SCRIPT_PATH/..

echo 'Updating remote content with new local push'
git add .
echo 'Adding new commit...'
message=\'$1\'
echo 'Commit message: ' $message
git commit -m $message
echo 'Pushing changes...'
git push
echo 'DONE'