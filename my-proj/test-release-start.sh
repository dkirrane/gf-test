#!/bin/bash

# Source environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/setenv.sh

read -r -p "Do you want to create Merge conflicts? [y/N]" choice

# Release Start
runCmd ${M2_HOME}/bin/mvn com.dkirrane.maven.plugins:ggitflow-maven-plugin:${GITFLOW_VERSION}:release-start $*

# Add some commits
runCmd git commit --allow-empty -m "JIRA-5 release commit"
runCmd git commit --allow-empty -m "JIRA-6 release commit"

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

	releaseBranch=`git branch | sed -e 's/*\s\+\|\s\+//g' | grep release`
	changeParentPom ${releaseBranch}
	changeModule1Pom ${releaseBranch}
	changeModule2Pom ${releaseBranch}

	pushAll

	echo -e "\n\n"
	echo -e "Merge Conflicts Created"
	echo -e "\n\n"

	echo -e "You should hit some Merge Conflicts on release finish..."
else
    echo -e "You should NOT hit Merge Conflicts on release finish..."
fi

echo -e "\n\n"
echo -e "Release branch created"
