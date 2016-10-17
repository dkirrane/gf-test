#!/bin/bash

# Source environment variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/setenv.sh

# Support Start (ServicePack) - e.g. release version 3.0.0.0 becomes support version 3.0.1.0-SNAPSHOT
runCmd ${M2_HOME}/bin/mvn com.dkirrane.maven.plugins:ggitflow-maven-plugin:${GITFLOW_VERSION}:support-start $*
