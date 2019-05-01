#!/bin/bash
#Please check the license provided with the script!
#-------------------------------------------------------------------------------------------------------------

update_script() {

local_branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
remote=$(git config branch.$local_branch.remote)

echo "Fetching from $remote..."
git fetch $remote

if git merge-base --is-ancestor $remote_branch HEAD; then
    remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
    dialog_msg "Already up-to-date Version ${remote_branch}"
    exit 0
fi

if git merge-base --is-ancestor HEAD $remote_branch; then
    git stash
    git merge --ff-only --stat $remote_branch
    remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u})
    dialog_msg "Merged to the new Version ${remote_branch}"
else
    echo 'Fast-forward not possible. Rebasing...'
    source ${SCRIPT_PATH}/script/functions.sh; continue_or_exit
    git rebase --preserve-merges --stat $remote_branch
fi
}