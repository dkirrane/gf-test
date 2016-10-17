#!/bin/sh
################################################################################
# Removes all Git history
# Reconstructs the repo with only the current content
# Pushes to origin
################################################################################

PROJ_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

GIT_BASE_DIR=$( git rev-parse --show-toplevel )
cd $GIT_BASE_DIR

##
# Clear gitflow config
##
git config --local --remove-section gitflow.branch
git config --local --remove-section gitflow.prefix
git config --local -l

##
# Removes all Git history
# Reconstructs the repo with only the current content
# Pushes to origin
##

git checkout develop

git fetch --all

ORIGIN=$(git config --get remote.origin.url)
echo ""
echo "Origin URL '$ORIGIN'"

##
# Delete remote tags
##
echo ""
echo "Deleting remote tags"
for remoteTag in $(git ls-remote --tags --refs --quiet | sed -e 's|.*refs/tags/||g'); do
    git push --delete origin ${remoteTag} -f
done

git fetch --all --prune

##
# Delete remote branches
##
echo ""
echo "Deleting remote branches"
for remoteBranch in $(git ls-remote --heads --refs --quiet | sed -e 's|.*refs/heads/||g'); do
    git push --delete origin ${remoteBranch} -f
done

git fetch --tags --all --prune

echo ""
echo "Resetting Maven version to 1.0-SNAPSHOT"
mvn -f $PROJ_DIR/pom.xml versions:set -DgenerateBackupPoms=false -DnewVersion=1.0-SNAPSHOT

echo ""
echo "Initialise Git repo"
cd $GIT_BASE_DIR
rm -rf .git
git init
git add --all
git commit -am "Initial commit. pom version 1.0-SNAPSHOT"

# git remote add origin https://github.com/dkirrane/ggitflow-test1.git
git remote add origin $ORIGIN
git push origin master --force --set-upstream

git fetch --all
git config --local -l

echo ""
echo "Done"
echo ""