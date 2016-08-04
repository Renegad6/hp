#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/rebase.sh,v 1.2 2016/08/02 09:29:08 deantoni Exp $
# Rebase branch: uso rebase.sh <sha> <branch>

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

if test -z "$1"
then
    echo "uso: $0 <sha> <branch>";
fi;
git checkout trunk;
git pull;
git rebase --onto $1 trunk $2;

exit 0;
