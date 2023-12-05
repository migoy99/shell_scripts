#!/bin/bash
#Add ssh private key to ssh-agent.
eval "$(ssh-agent)" && ssh-add ~/.ssh/sample-private-key

#Fetch latest tags from remote repo.
git fetch --tags

#Get latest tag and store in a variable.
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)

#Checkout the latest tag.
git checkout $latestTag
