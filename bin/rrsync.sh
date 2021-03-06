#!/bin/sh 
# $Header:$
# sync current folder with remote one (remote -> local).Must have a 'rrsync' file on current folder.
# Structure: every line:
#   user@host,remote_folder,local_folder,delete
# args:
#   -r: Reverse sync direction (local -> remote).

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;
if test -z "$1"
then
    RRSYNC=$MYSBOX/ign.rrsync;
else
    RRSYNC=$1/ign.rrsync;
fi;
if ! test -f $RRSYNC
then
    echo "'$RRSYNC' file does not exist!";
    exit -1;
fi;


LROOT=$(head -3 $RRSYNC|grep "^L:"|cut -f2 -d':');
RROOT=$(head -3 $RRSYNC|grep "^R:"|cut -f2 -d':');
if [ $LROOT = "AE_SANDBOX_PATH" ]
then
    LROOT=$AE_SANDBOX_PATH;
fi;
if [ $RROOT = "AE_SANDBOX_PATH" ]
then
    RROOT=$AE_SANDBOX_PATH;
fi;
if [ $LROOT = "PWD" ]
then
    LROOT=$PWD;
fi;
if [ $RROOT = "PWD" ]
then
    RROOT=$PWD;
fi;
if [ $LROOT = "MYSBOX" ]
then
    LROOT=$MYSBOX;
fi;
if [ $RROOT = "MYSBOX" ]
then
    RROOT=$MYSBOX;
fi;
USER=$(head -3 $RRSYNC|grep "^U:"|cut -f2 -d':');
if [ -z "$LROOT" ] || [ -z "$RROOT" ]
then
    echo "error in $RRSYNC!!!";
    exit -1;
fi;
cat $RRSYNC|grep -v "^#"|grep -v "^[A-Z]:"|grep "[^/]$" > /tmp/check_no_ending_slash;
if [ -s /tmp/check_no_ending_slash ]
then
    echo "paths not ending with / found!";
    cat /tmp/check_no_ending_slash;
    exit -1;
fi;

for record in $(cat $RRSYNC|grep -v "^#"|grep -v "^[A-Z]:");
do
#echo $record
    FOLD=$(echo $record);
    LFOLD="$LROOT"/"$FOLD";
    RFOLD="$RROOT"/"$FOLD";
if [ "$1" == -r ]
then
    echo "U:$USER,R:$LFOLD,L:$RFOLD";
    if ! test -d "$RFOLD"
    then
        mkdir -p $RFOLD;
    fi;
    rsync $EXTRAPAR -ac --delete --exclude "*/" --exclude '.svn' $USER:$LFOLD $RFOLD;
else
    echo "U:$USER,R:$RFOLD,L:$LFOLD";
    if ! test -d "$LFOLD"
    then
        mkdir -p $LFOLD;
    fi;
    rsync $EXTRAPAR -ac --delete --exclude "*/" --exclude '.svn' $USER:$RFOLD $LFOLD;
fi;

done;

cd $(dirname $RRSYNC);
#svn status |grep -v "ign\."|grep "^?"
git status -s|grep -v "ign\."|grep "^?"
if [ $? == 0 ]
then
    echo "WARNING: new unversioned files detected in $(dirname $RRSYNC).!!!";
fi;
cd -;

exit 0;
