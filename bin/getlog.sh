#!/bin/sh -e
# $Header:$
# Recupera printer.log a intervalos
# getlog.sh <ip> [<intervalo>]

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;

IP=$1;
INT=$2;

if test -z "$IP"
then
    echo "wrong ip!";
    exit -1;
fi;

if test -z "$INT"
then
    INT=60;
fi;

if ! test -d logs
then
    mkdir -p logs;
fi;

touch ./logs/default.gz
C=1;
while true;
do
    rm -f /tmp/*printer.log /tmp/*printer.log.gz;
    scp -p root@$IP:/tmp/printer.log /tmp/$$printer.log >> ./logs/trz 2>&1;
    gzip /tmp/$$printer.log;
    NEW=$(newest_matching_file './logs/*.gz');
#echo "new="$NEW;
    if ! test -z "$NEW"
    then
        RES=0;
        cmp /tmp/$$printer.log.gz $NEW || RES=$?;
#echo "res="$RES;
        if [ $RES = 0 ]
        then
            echo "$(date) skipping" >> ./logs/trz;
        else
            mv /tmp/$$printer.log.gz ./logs/${C}_printer.log.gz;
        fi;
        let C=C+1;
    fi;
    sleep $INT;
done;
