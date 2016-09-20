#!/bin/sh
# $Header: /usersnfs/deantoni/common/bin/RCS/rebtags.sh,v 1.1 2016/08/02 06:45:34 deantoni Exp $

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh
TRZ=~/rebtags.trz;

LUX_BIN=$(getScriptPath)
echo "$(date): rebuild tags/cscope db" 2>&1 | tee -a $TRZ;
if ! test -d "$1";
then
    echo "$1 not found!" 2>&1|tee -a $TRZ;
    exit -1;
fi;
cd $1;

#$LUX_BIN/bscope > /dev/null 2>&1;
$LUX_BIN/btags > /dev/null 2>&1;

echo "$(date): rebuild tags/cscope done" 2>&1 | tee -a $TRZ;

exit 0;
