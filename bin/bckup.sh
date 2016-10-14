#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/bckup.sh,v 1.5 2016/08/04 07:34:55 deantoni Exp $
# A 'repos' file must exist on the backup dir.
# Its structure must be (all the branches that must be backed up)
# <sandbox path>#<branch>
# <sandbox path>#<branch>
# <sandbox path>#<branch>
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

exit 0;
