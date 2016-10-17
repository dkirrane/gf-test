#!/bin/bash

# Source environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/setenv.sh

# Support Tag (ServicePack) - e.g. release tag 3.0.1 is branched off as version 3.0.1-x support branch with initial version set to 3.0.1-1-SNAPSHOT
runCmd ${M2_HOME}/bin/mvn com.dkirrane.maven.plugins:ggitflow-maven-plugin:${GITFLOW_VERSION}:support-tag $*
