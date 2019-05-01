#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_script() {

git remote update
if git diff --quiet origin/master; then
  cd ${SCRIPT_PATH}
  git pull origin master
  GIT_LOCAL_FILES_HEAD=$(git rev-parse --short HEAD)
else
  GIT_LOCAL_FILES_HEAD=$(git rev-parse --short HEAD)
  dialog_msg "The local Version ${GIT_LOCAL_FILES_HEAD} is equal with Github, no update needed!"
  exit 1
fi
}
