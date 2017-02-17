#!/bin/bash

TMPFILE=$(mktemp /tmp/XXXX)
exec <"$6"
cat - > $TMPFILE
chmod a+x $TMPFILE
$TMPFILE
rm -f $TMPFILE
exit 0;
