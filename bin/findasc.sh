aefind -name .svn -prune -o -type f -exec file {} \; |grep -i text|cut -f1 -d':'|xargs grep -i $1 2>/dev/null;
