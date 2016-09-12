#!/bin/sh -e
# $Header:$
# Remerge after a sync.A 'cherry' file must exist in local dir.
# Its structure must be:
# keyw1 keyw2,...
# Those revisions NOT containing any of the keywords, will be merged.

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if ! test -f cherry
then
    echo "'cherry' file does not exist!";
    exit -1;
fi;

/opt/CollabNet_Subversion/bin/svn update;
/opt/CollabNet_Subversion/bin/svn log | perl -l40pe 's/^-+/\n/' >/tmp/$$cherr_rev;

for kw in $(cat cherry);
do
echo $kw;
    grep -i -v $kw /tmp/$$cherr_rev > /tmp/$$new_cherry;
    mv /tmp/$$new_cherry /tmp/$$cherr_rev;
done;

for rev in $(tac /tmp/$$cherr_rev|cut -f1 -d'|'|sed -e"s/^ *r//"); # 'tac' list file in reverse order
do
echo $rev;
    /opt/CollabNet_Subversion/bin/svn merge -c $rev .
done;

exit 0;
