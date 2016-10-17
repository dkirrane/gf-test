#!/bin/bash

# Source environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/setenv.sh

read -r -p "Do you want to create Merge conflicts? [y/N]" choice

# Hotfix Start - e.g. a release version 3.0.0.0 becomes hotfix version 3.0.0.1-SNAPSHOT
runCmd ${M2_HOME}/bin/mvn com.dkirrane.maven.plugins:ggitflow-maven-plugin:${GITFLOW_VERSION}:hotfix-start $*

# Add some commits
runCmd git commit --allow-empty -m "JIRA-7 hotfix commit"
runCmd git commit --allow-empty -m "JIRA-8 hotfix commit"

# Add some Merge Conflicts
if [[ $choice =~ ^([yY][eE][sS]|[yY])$ ]]
then
	echo -e "\n\n"
	echo -e "Creating some Merge Conflicts"

	changeParentPom develop
	changeModule1Pom develop
	changeModule2Pom develop

	changeParentPom master
	changeModule1Pom master
	changeModule2Pom master

	hotfixBranch=`git branch | sed -e 's/*\s\+\|\s\+//g' | grep hotfix`
	changeParentPom ${hotfixBranch}
	changeModule1Pom ${hotfixBranch}
	changeModule2Pom ${hotfixBranch}

	pushAll

	echo -e "\n\n"
	echo -e "Merge Conflicts Created"
	echo -e "\n\n"

	echo -e "You should hit some Merge Conflicts on hotfix finish..."
else
    echo -e "You should NOT hit Merge Conflicts on hotfix finish..."
fi

echo -e "Hotfix branch created with some dummy commits"
