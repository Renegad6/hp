#!/bin/sh -e
# $Header:$
# A 'repos' file must exist on the backup dir with all repositories to be bcked up
# in those repos all branches will be backed , they must be tracking remote branches for it to work
#...

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

svn diff > x;
# isd -> quizas particularizar por maquina
grep \.isd x  > /dev/null 2>&1 
if [ $? -eq 1 ] 
then
    echo "isd's presentes, quizas particularizar por maquina?"
fi;

exit 0;
