#!/bin/sh -e
# $Header:$
# Commit de svn con proteccion para no hacerlo en una sandbox.
#...

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if test -z "$1";
then
    echo "No comments!!";
    exit -1;
fi;

if [ -z "$AE_SANDBOX_PATH" ]
then
    echo "ae_init_sandbox not performed, impossible to detect risks!!!";
    exit -1;
fi;

if [ "$AE_SANDBOX_PATH" = "$PWD" ];
then
    echo "trying commit from REAL!!! sandbox!!";
    exit -1;
fi;
svn commit -m"$1"
exit 0;
