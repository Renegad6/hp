#!/bin/sh -e
# $Header:$
# svn repo compare.
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

if [ "$AE_SANDBOX_PATH" = "$PWD" ];
then
    echo "trying compare from REAL!!! sandbox!!";
    exit -1;
fi;

BRANCH=$(basename $PWD);

svn diff ^/trunk ^/branches/$BRANCH --summarize;
svn diff ^/trunk ^/branches/$BRANCH --internal-diff > svn_patch_$BRANCH;

exit 0;
