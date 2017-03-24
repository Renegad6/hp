svn st | grep '^?' |grep -v "ign\."| awk '{print $2}' | xargs rm -rf
