#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/bckup.sh,v 1.5 2016/08/04 07:34:55 deantoni Exp $
# A 'repos' file must exist on the backup dir with all repositories to be bcked up
# in those repos all branches will be backed , they must be tracking remote branches for it to work
#...

getScriptPath () {
  echo ${0%/*}/
}

BCKDIR=/usersnfs/$USER/common/backup
TRZ=~/bckup.trz;

source $(getScriptPath)/common.sh;

if ! test -d $BCKDIR
then
    echo "$BCKDIR does not exist!">>$TRZ;
    exit -1;
fi;

if ! test -f $BCKDIR/repos
then
    echo "$BCKDIR/repos does not exist!">>$TRZ;
    exit -1;
fi;

echo "$(date) begin bck" >> $TRZ;
for REPO in $(cat $BCKDIR/repos|grep -v "^#");
do
    cd $REPO;
    echo "$(date) backing up: "$REPO >> $TRZ;
# First update trunk or diff wont work!
    git fetch --all >> $TRZ 2>&1;
# For all local branches
    BRANCHES=$(git branch|grep -v trunk|awk -F ' +' '! /\(no branch\)/ {print $2}');
    for BRANCH in $(echo $BRANCHES);
    do
      ORIG=origin/$(git branch -vv|grep $BRANCH|sed -e"s/^.*origin\///"|cut -f1 -d':');
      echo "$(date)  ...... backing up: "$BRANCH:$ORIG >> $TRZ;
      TS=$(timestamp);
      FILE=$(basename $REPO).$BRANCH.$TS.diff.gz;
      git diff $(git merge-base --fork-point $ORIG)..$BRANCH| gzip -c > $BCKDIR/$FILE;
    done;
done;
echo "$(date) end bck" >> $TRZ;

# Dump de svnrep (todos los proyectos)
echo "$(date)  backing up svnrep " >> $TRZ;
for d in $(ls -d /users/deantoni/svnrep/*);
do
    PRJ=$(basename $d);
    echo "$(date)  ...... backing up: $PRJ " >> $TRZ;
    (/opt/CollabNet_Subversion/bin/svnadmin dump $d |gzip -c > /usersnfs/deantoni/common/backup/svnrep_$PRJ.dump.gz) > /dev/null 2>&1;
done;

exit 0;
