#!/bin/bash

# Moves last commit to a new branch and pushes to remote

set -ex

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
STASH_DUMMY=$(date +%s).stash

# Create dummy file to avoid non stash generation and stash everything
touch $STASH_DUMMY
git stash -u

# Create and checkout new branch
git checkout -b $1

# Push current branch to remote
git push -u origin HEAD:$1

# Checkout previous branch and remove topmost commit
git checkout $CURRENT_BRANCH
git reset --hard HEAD~

# Pop stashed changes and remove dummy file
git stash pop
rm $STASH_DUMMY

