svn status $AE_SANDBOX_PATH |grep "^?"|grep -v "ign\."|sed -e"s/  */:/"|cut -f2 -d:|xargs svn add
