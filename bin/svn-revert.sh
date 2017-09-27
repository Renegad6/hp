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

svn status $AE_SANDBOX_PATH|grep "^[M|A]"| cut -f2- -d" " > /tmp/$$svnrevert;
svn revert -R .;
for f in $(cat /tmp/$$svnrevert);
do
    echo $f;
    touch $f;
done;

exit 0;
