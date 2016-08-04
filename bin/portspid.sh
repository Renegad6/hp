#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/portspid.sh,v 1.1 2016/08/02 06:45:34 deantoni Exp $

if test -z "$1";
then
    echo "uso $0 <PID>";
    exit -1;
fi;
sudo lsof -Pan -p $1 -i
exit 0;
