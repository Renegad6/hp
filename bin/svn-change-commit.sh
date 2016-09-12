#!/bin/bash -e

TMP_COMMIT_FILE=/tmp/changecommit

function help {
   local scriptname="$(basename $0)"
   cat >&2 <<EOF
$scriptname [options] [args]
Change a svn commit.
Options:
   -r, --repo          path to repository (no url,svn or file protocol).
   -n, --revision      Revision to change.
   -c, --commit        New commit message.
   -h, --help            If there is only one match launch it.

Examples:
 # change a commit adding issue tracker reference
 $ $scriptname -r $HOME/projects/svnrepo -n265 "New message\n\nfixes#532"
EOF
}

TEMP=$(getopt -o "r:n:c:h" -l repo:,revision:,commit:,help -n $(basename $0) -- "$@")

EXIT=$?
if [ $EXIT != 0 ]
then
   help
   exit $EXIT
fi

# process script arguments
eval set -- "$TEMP"

while true
do
   case "$1" in
      -r|--repo)
         REPO="$2"
         shift
         ;;
      -n|--revision) 
         REVISION="$2" 
         shift
         ;;
      -c|--commit) 
         COMMIT="$2" 
         shift
         ;;
      -h|--help)
         help
         exit
         ;;
      --)
         shift
         break ;;
      *)
         cat <&2 <<EOF
Error, unknow arguments $1
EOF
         help
         exit 1
         ;;
   esac
   shift
done

if [ -z "$REPO" ]
then
        echo Missing repo option
        EXITCODE=1
fi

if [ -z "$REVISION" ]
then
        echo Missing revision option
        EXITCODE=1

fi

if [ -z "$COMMIT" ]
then
        echo Missing commit option
        EXITCODE=1
fi

if [ -n "$EXITCODE" ]
then
        help
        exit $EXITCODE
fi

svn log file://$REPO -r $REVISION
echo -e "$COMMIT" > $TMP_COMMIT_FILE
svnadmin setlog $REPO -r$REVISION  --bypass-hooks $TMP_COMMIT_FILE
rm $TMP_COMMIT_FILE
svn log file://$REPO -r $REVISION

exit 0;
