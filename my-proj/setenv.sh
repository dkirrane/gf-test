#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export GITFLOW_VERSION="3.0"
# export M2_HOME=C:/apache-maven-3.0.5
export M2_HOME=C:/apache-maven-3.3.9

# Maven attach Debugger
# export MAVEN_OPTS="-Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8000"

# Maven attach Netbeans Profiler
# https://blogs.oracle.com/nbprofiler/entry/space_in_path_on_windows
# Need to install NetBeans to a path wihtout spaces
# export MAVEN_OPTS="-agentpath:C:\\NetBeans8.1\\profiler\\lib\\deployed\\jdk16\\windows-amd64\\profilerinterface.dll=C:\\NetBeans8.1\\profiler\\lib,5140"

echo "GITFLOW_VERSION=${GITFLOW_VERSION}"
echo "M2_HOME=${M2_HOME}"
echo "MAVEN_OPTS=${MAVEN_OPTS}"

# Delete old Gitflow plugin
MAVEN_REPO=`${M2_HOME}/bin/mvn help:evaluate -Dexpression=settings.localRepository | grep -v '\[INFO\]' | grep -v 'Download'`
echo "MAVEN_REPO=${MAVEN_REPO}"
PLUGIN_DIR="${MAVEN_REPO}/com/dkirrane"

if [ -d "$PLUGIN_DIR" ]; then
	echo -e ""
	read -r -p "Do you want to delete ggitflow-maven-plugin from local Maven repo '${PLUGIN_DIR}' ? [y/N]" choice
	if [[ $choice =~ ^([yY][eE][sS]|[yY])$ ]]
	then
		rm -Rf ${PLUGIN_DIR}
	else
	    echo -e ""
	fi
fi

function runCmd {
    echo "\$ $@" ; "$@" ;
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Failed to run with $1" >&2
        exit
    fi
    return $status
}

function changeParentPom {
	echo -e "\n\n"
    local timestamp=`date --rfc-3339=seconds`
    runCmd git checkout $1
    runCmd sed -i -e "s|<description>my-proj.*</description>|<description>my-proj ${timestamp}</description>|g" $DIR/pom.xml
	runCmd git commit -am "Parent pom change on $1 to cause merge-conflict"
}

function changeModule1Pom {
	echo -e "\n\n"
    local timestamp=`date --rfc-3339=seconds`
    runCmd git checkout $1
    runCmd sed -i -e "s|<description>my-proj-module1.*</description>|<description>my-proj-module1 ${timestamp}</description>|g" $DIR/my-proj-module1/pom.xml
	runCmd git commit -am "my-proj-module1 pom change on $1 to cause merge-conflict"
}

function changeModule2Pom {
	echo -e "\n\n"
    local timestamp=`date --rfc-3339=seconds`
    runCmd git checkout $1
    runCmd sed -i -e "s|<description>my-proj-module2.*</description>|<description>my-proj-module2 ${timestamp}</description>|g" $DIR/my-proj-module2/pom.xml
	runCmd git commit -am "my-proj-module2 pom change on $1 to cause merge-conflict"
}

function changeModule2App {
	echo -e "\n\n"
    local timestamp=`date --rfc-3339=seconds`
    runCmd git checkout $1
    runCmd sed -i -e "s/\"Hello Module2.*\"/\"Hello Module2 ${timestamp}\"/g" $DIR/my-proj-module2/src/main/java/com/mycompany/module2/App.java
	runCmd git commit -am "Commit change on $1 to cause merge-conflict"
}

function pushAll {
	echo -e "\n\n"
	echo -e "Pushing all branches"
    runCmd git push --all
}
