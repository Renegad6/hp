#!/bin/sh
# $Header: /usersnfs/deantoni/common/bin/RCS/bckup.sh,v 1.5 2016/08/04 07:34:55 deantoni Exp $
# A 'repos' file must exist on the backup dir with all repositories to be bcked up
# in those repos all branches will be backed , they must be tracking remote branches for it to work
#...

getScriptPath () {
  echo ${0%/*}/
}

TRZ=~/bckup.trz;
source $(getScriptPath)/common.sh;

if test -z "$USER"
then
    USBCK=$1;
else
    USBCK=$USER;
fi;

if test -z "$USBCK"
then
    echo "user not defined!">>$TRZ;
    exit -1;
fi;

echo "backing up for user:"$USBCK>>$TRZ;

BCKDIR=/usersnfs/$USBCK/common/backup

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
# Dump diff of current branch against fork point. (WARNING: never leave a remote branch checked out in the repo!!!!) branches to be backed up begin with "my!"
    BRANCH=$(git branch|grep "^\*"|sed -e"s/^\* *//"|grep "^ *my");
    if ! test -z "$BRANCH"
    then
        ORIG=$(git rev-parse --abbrev-ref --symbolic-full-name @{u});
        echo "$(date)  ...... backing up: "$BRANCH:$ORIG >> $TRZ;
        TS=$(timestamp);
        FILE=$(basename $REPO).$BRANCH.$TS.diff.gz;
        echo "backing up:"$BRANCH" against:"$ORIG >> $TRZ;
        git diff $(git merge-base --fork-point $ORIG)..HEAD| gzip -c > $BCKDIR/$FILE;
    fi;
    done;
echo "$(date) end bck" >> $TRZ;

# Dump de svnrep (todos los proyectos)
echo "$(date)  backing up svnrep " >> $TRZ;
for d in $(ls -d /users/deantoni/svnrep/*);
do
    PRJ=$(basename $d);
    echo "$(date)  ...... backing up: $PRJ " >> $TRZ;
    (/usr/bin/svnadmin dump $d |gzip -c > /usersnfs/deantoni/common/backup/svnrep_$PRJ.dump.gz) > /dev/null 2>&1;
done;

# Dump de gitrep 
echo "$(date)  backing up gitrep ($GIT_DIR)" >> $TRZ;
export GIT_DIR=/ae/git/.git
git bundle create /usersnfs/deantoni/common/backup/gitrep.dmp --all
gzip -f /usersnfs/deantoni/common/backup/gitrep.dmp
exit 0;
