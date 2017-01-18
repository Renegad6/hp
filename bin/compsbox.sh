#!/bin/sh -e
# $Header: $

getScriptPath () {
  echo ${0%/*}/
}

if test -z "$1" 
then
    exit -1;
fi;

SBOX=$1;
cd /ae
/ae/_tools/contract/ae_init_sandbox $SBOX > $HOME/compila_$SBOX.trz
cd /ae/$SBOX/work
. $AE_SANDBOX_PATH/work/setup wrl80-haswell-dbg jaguar >> $HOME/compila_$SBOX.trz
gmake clean all >> $HOME/compila_$SBOX.trz

exit 0;
