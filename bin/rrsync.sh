#!/bin/sh -e
# $Header:$
# sync current folder with remote one.Must have a 'rrsync' file on current folder.
# Structure: every line:
#   user@host,remote_folder,local_folder

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if ! test -f rrsync
then
    echo "'rrsync' file does not exist!";
    exit -1;
fi;

for record in $(cat rrsync|grep -v "^#");
do
echo $record
    USER=$(echo $record|cut -f1 -d',');
    RFOLD=$(echo $record|cut -f2 -d',');
    LFOLD=$(echo $record|cut -f3 -d',');
echo "U:$USER,R:$RFOLD,L:$LFOLD";
    rsync -a --exclude '.svn' $USER:$RFOLD $LFOLD;
done;

exit 0;
