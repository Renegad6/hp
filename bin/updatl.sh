rm -f ~/updatl.trz;
echo "$(date) updating tools dir(lib)" > ~/updatl.trz;
/usr/bin/doatlas /ae/_tools/contract/update_atlas_libs.sh >> ~/updatl.trz 2>&1;
echo "$(date) updating tools dir(tools)" >> ~/updatl.trz;
/usr/bin/doatlas /ae/_tools/contract/update_atlas_tools.sh >> ~/updatl.trz 2>&1;
