YAML=$(ls -lt ~/Downloads/*.yaml|head -1|sed -e"s/  */ /g"|cut -f9 -d' ');
mv $YAML /sirius/work/$USER/local_sirius_dist;
cd /sirius/work/$USER/local_sirius_dist;
ln -fs $(basename $YAML) lux_dist_bb1.yaml;
echo "Installed: $YAML";
exit 0;
