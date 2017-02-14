svn status |grep "^?"|sed -e"s/  */:/"|cut -f2 -d:|xargs svn add
