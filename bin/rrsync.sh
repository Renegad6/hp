#!/bin/sh -e
# $Header:$
# sync current folder with remote one.Must have a 'rrsync' file on current folder.
# Structure: every line:
#   user@host,remote_folder,local_folder,delete

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if ! test -f rrsync
then
    echo "'rrsync' file does not exist!";
    exit -1;
fi;

EXTRAPAR="";
for record in $(cat rrsync|grep -v "^#");
do
#echo $record
    USER=$(echo $record|cut -f1 -d',');
    RFOLD=$(echo $record|cut -f2 -d',');
    LFOLD=$(echo $record|cut -f3 -d',');
    DEL=$(echo $record|cut -f4 -d',');
echo "U:$USER,R:$RFOLD,L:$LFOLD:$DEL";
if ! test -z "$DEL";
then
    EXTRAPAR=$EXTRAPAR\ --delete;
fi;
rsync $EXTRAPAR -a --exclude '.svn' $USER:$RFOLD $LFOLD;
done;

exit 0;
