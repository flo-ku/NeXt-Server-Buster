#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_script() {

SCRIPT_PATH="/root/NeXt-Server-Buster" 
cd ${SCRIPT_PATH}

UPSTREAM=${1:-'@{u}'}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
elif [ $LOCAL = $BASE ]; then
    git reset --hard origin/master
    dialog_msg "Finished updating NeXt Server Script to Version ${GIT_LOCAL_FILES_HEAD}"
else
    echo "Diverged"
fi
}




          