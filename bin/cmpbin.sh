#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/cmpbin.sh,v 1.1 2016/08/02 06:45:34 deantoni Exp $
# Binary cmp between two files.

if ! test -f "$1" || ! test -f "$2";
then
    echo "use $0 <file1> <file2>";
    exit -1;
fi;

cmp -l $1 $2| 
gawk 'function oct2dec(oct,     dec) {
          for (i = 1; i <= length(oct); i++) {
              dec *= 8;
              dec += substr(oct, i, 1)
          };
          return dec
      }
      {
          printf "%08X %02X %02X\n", $1, oct2dec($2), oct2dec($3)
      }'


exit 0;
