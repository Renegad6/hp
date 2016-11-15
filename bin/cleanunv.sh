# removes unversioned files in svn rep.

svn status | grep ^\? | cut -c9- | xargs -d \\n rm -rf ;
