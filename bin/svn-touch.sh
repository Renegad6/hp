svn status $AE_SANDBOX_PATH|tee /tmp/$$touch;
grep "^[M|A]" /tmp/$$touch| cut -f2- -d" "|xargs touch ;
rm -f /tmp/$$touch;
