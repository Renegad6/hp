if test -z "$1" 
    exit -1;
fi;

SBOX=$1
/ae/_tools/contract/ae_init_sandbox/ae_init_sandbox /ae/$SBOX > $HOME/compila_$SBOX.trz
cd /ae/$SBOX
/ae/_tools/contract/ae_init_sandbox/ae_refresh_sandbox >> $HOME/compila_$SBOX.trz
cd /ae/$SBOX/work
. $AE_SANDBOX_PATH/work/setup wrl80-haswell-dbg jaguar >> $HOME/compila_$SBOX.trz
gmake all >> $HOME/compila_$SBOX.trz
