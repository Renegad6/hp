#!/bin/sh -e
# $Header:$
# Commit de svn con proteccion para no hacerlo en una sandbox.
#...

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if [ "$AE_SANDBOX_PATH" = "$PWD" ];
then
    echo "trying commit from REAL!!! sandbox!!";
    exit -1;
fi;

exit 0;
