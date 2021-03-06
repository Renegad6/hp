#!/bin/sh -e
# $Header:$
# Commit de svn con proteccion para no hacerlo en una sandbox.
#...

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if [ -z "$AE_SANDBOX_PATH" ]
then
    echo "ae_init_sandbox not performed, impossible to detect risks!!!";
    exit -1;
fi;

workingwith;

ae_tupdate $*;

exit 0;
