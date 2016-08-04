#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/tag2sha.sh,v 1.1 2016/08/02 06:45:34 deantoni Exp $
# Obtains sha associated with tag in the sandbox

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if test -z "$1";
then
    echo "use: $0 <tag>";
    exit -1;
fi;

git tag|grep $1> /tmp/$$tags2;

for tag in $(cat /tmp/$$tags2);
do
    echo $tag;
    git rev-list -n 1 $tag;
done;

exit 0;
