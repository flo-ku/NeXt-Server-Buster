#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_script() {

local_branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
remote=$(git config branch.$local_branch.remote)

dialog_msg "Fetching from ${remote}..."
git fetch $remote

if git merge-base --is-ancestor $remote_branch HEAD; then
    GIT_LOCAL_FILES_HEAD=$(git rev-parse --short HEAD)
    dialog_msg "Already up-to-date Version ${GIT_LOCAL_FILES_HEAD}"
fi

if git merge-base --is-ancestor HEAD $remote_branch; then
    git stash
    git merge --ff-only --stat $remote_branch
    GIT_LOCAL_FILES_HEAD=$(git rev-parse --short HEAD)
    dialog_msg "Merged to the new Version ${GIT_LOCAL_FILES_HEAD}"
else
    echo 'Fast-forward not possible. Rebasing...'
    source ${SCRIPT_PATH}/script/functions.sh; continue_or_exit
    git rebase --preserve-merges --stat $remote_branch
fi
}