#!/bin/bash

# Source environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/setenv.sh

# Feature Start
runCmd ${M2_HOME}/bin/mvn com.dkirrane.maven.plugins:ggitflow-maven-plugin:${GITFLOW_VERSION}:feature-start -DfeatureName=JIRA-1-Feature $*

runCmd git commit --allow-empty -m "JIRA-1 feature commit"
runCmd git commit --allow-empty -m "JIRA-2 feature commit"

echo -e "\n\n"
echo -e "Feature branch 1 created with some dummy commits"
