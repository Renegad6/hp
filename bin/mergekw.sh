#!/bin/sh -e
# $Header:$
# Remerge after a sync.A 'keyw' file must exist in local dir.
# Its structure must be:
# keyw1 keyw2,...
# Those revisions NOT containing any of the keywords, will be merged.

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if ! test -f keyw
then
    echo "'keyw' file does not exist!";
    exit -1;
fi;

/opt/CollabNet_Subversion/bin/svn update;
/opt/CollabNet_Subversion/bin/svn log | perl -l40pe 's/^-+/\n/' >/tmp/$$keyw_rev;

# fuera a partir del primer merge
cat > /tmp/$$keyw.awk << EOF
BEGIN{fuera=0;}
{
    fuera=(fuera || match(\$0,"merged"));
    if(!fuera) print \$0;
}
EOF
awk -f /tmp/$$keyw.awk  /tmp/$$keyw_rev > /tmp/$$new_keyw;
mv /tmp/$$new_keyw /tmp/$$keyw_rev;


for kw in $(cat keyw);
do
echo $kw;
    grep -i -v $kw /tmp/$$keyw_rev > /tmp/$$new_keyw;
    mv /tmp/$$new_keyw /tmp/$$keyw_rev;
done;

for rev in $(tac /tmp/$$keyw_rev|cut -f1 -d'|'|sed -e"s/^ *r//"); # 'tac' list file in reverse order
do
echo $rev;
# svn merge -c doesnt work! (maybe bcause mergeinfo issues)
    /opt/CollabNet_Subversion/bin/svn diff -c $rev > /tmp/$$keyw_patch;
    /opt/CollabNet_Subversion/bin/svn patch /tmp/$$keyw_patch;
done;

exit 0;
