#!/bin/bash

# Moves last commit to a new branch and pushes to remote

set -ex

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ $CURRENT_BRANCH != "master" ]; then
	echo "Current branch is not master! Aborting"
	exit 1
fi

$NEW_VERSION=$1
$DIST_DIR=dist

# Generate new version using semver
yarn version --new-version $NEW_VERSION

# Push master update
git push origin master

# Delete created tag
$CREATED_TAG=$(git describe --tags --abbrev=0)
git tag -d $CREATED_TAG

# Generate branch to create a new tag that includes the dist version
$CREATED_TAG_TMP_BRANCH="$CREATED_TAG-tmp-branch"
git checkout -b $CREATED_TAG_TMP_BRANCH

# Build and add dist to git
yarn run build
git add -f $DIST_DIR

# Create new tag from version and push
git commit -m $CREATED_TAG
git tag $CREATED_TAG
git push origin $CREATED_TAG

# Go back to master and delete tmp branch
git checkout master
git branch -D $CREATED_TAG_TMP_BRANCH

