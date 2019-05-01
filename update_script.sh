#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_script() {

changed=0
git remote update && git status -uno | grep -q 'Your branch is behind' && changed=1
if [ $changed = 1 ]; then
    git pull
    $(git rev-parse --short HEAD)
    dialog_msg "Update to version ${GIT_LOCAL_FILES_HEAD} successfull!"
    echo "Updated successfully";
else
    $(git rev-parse --short HEAD)
    dialog_msg "The local Version ${GIT_LOCAL_FILES_HEAD} is equal with Github, no update needed!"
fi
}
