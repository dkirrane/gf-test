#!/bin/bash

# Source environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/setenv.sh

# Release Finish
runCmd ${M2_HOME}/bin/mvn com.dkirrane.maven.plugins:ggitflow-maven-plugin:${GITFLOW_VERSION}:release-finish $*
