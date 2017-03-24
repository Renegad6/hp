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

if ! test -f ign.rrsync
then
    echo "'ign.rrsync' file does not exist!";
    exit -1;
fi;


LROOT=$(head -3 ign.rrsync|grep "^L:"|cut -f2 -d':');
RROOT=$(head -3 ign.rrsync|grep "^R:"|cut -f2 -d':');
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
USER=$(head -3 ign.rrsync|grep "^U:"|cut -f2 -d':');
if [ -z "$LROOT" ] || [ -z "$RROOT" ]
then
    echo "error in ign.rrsync!!!";
    exit -1;
fi;
cat ign.rrsync|grep -v "^#"|grep -v "^[A-Z]:"|grep "[^/]$" > /tmp/check_no_ending_slash;
if [ -s /tmp/check_no_ending_slash ]
then
    echo "paths not ending with / found!";
    cat /tmp/check_no_ending_slash;
    exit -1;
fi;

for record in $(cat ign.rrsync|grep -v "^#"|grep -v "^[A-Z]:");
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

svn status |grep "^?"
if [ $? == 0 ]
then
    echo "WARNING: new unversioned files detected.!!!";
fi;

exit 0;
