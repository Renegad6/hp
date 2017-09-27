svn st $AE_SANDBOX_PATH | grep '^?' |grep -v "ign\."| awk '{print $2}' | xargs rm -rf
