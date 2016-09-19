find . -name .svn -prune -o -type f -exec file {} \; |grep -vi binary|cut -f1 -d':'|xargs grep -i $1;
