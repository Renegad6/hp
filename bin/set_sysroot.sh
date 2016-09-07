#!/bin/sh
# $Header: /usersnfs/deantoni/common/bin/RCS/set_sysroot.sh,v 1.4 2016/08/02 12:18:32 deantoni Exp $

getScriptPath () {
  echo ${0%/*}/
}

source $(getScriptPath)/common.sh;
TARGET=arel;
RECIPE=/sirius/work/$USER/local_sirius_dist/lux_dist_bb1.yaml;
ONLYD=;
DEST=$(ropkg show);
if ! test -f "$RECIPE"
then
    echo "$RECIPE not found!";
    exit -1;
fi;

while [ "$1" != "" ]; do
    case $1 in
        -r | --recipe )         shift
                                RECIPE=$1;
                                if ! test -f "$RECIPE"
                                then
                                  echo "$RECIPE not found!";
                                  exit -1;
                                fi;
                                ;;
        -t | --target )         shift
                                TARGET=$1;
                                ;;
        -h | --help )           echo "use: $0 [-r <recipe>] [-t <target>] [-c]";
                                exit -1;
                                ;;
        -o | --download )       ONLYD=1;
                                ;;
        -c | --compare )        ropkg list-installed|sed -e"s/ \- /=/"|sed -e"s/-devel//"|sort -u > /tmp/$$sets_a;
                                grep "^ *\- " $RECIPE|grep -v http|sed -e"s/^ *\- *//"|sed -e"s/_\%t/_$TARGET/"|grep -v "[-_]sim[_-=]"|sort -u > /tmp/$$sets_b;
                                diff -C1 /tmp/$$sets_a /tmp/$$sets_b;
                                exit 0; #automatically cleans
                                ;;
        * )                     echo "use: $0 [-r <recipe>] [-t <target>] [-c]";
                                exit -1;
    esac
    shift
done;

mkdir -p /tmp/$$setsys;
SYSROOT=$DEST/opt/hpinstall/opkg/lists;
grep "^ *\- " $RECIPE|grep -v http|sed -e"s/^ *\- *//"|grep -v "[-_]sim[_-=]"|sort -u > /tmp/$$deps1;
grep "local:" $RECIPE|sed -e"s/^ *\- *//"|grep -v "[-_]sim[_-=]"|cut -f2 -d':'|cut -f1 -d','|sed -e"s/  *//g"|sort -u > /tmp/$$local;
for f in $(cat /tmp/$$deps1);
do
    nf=$(echo $f|sed -e"s/  *//g"|cut -f1 -d'='|sed -e"s/_\%[rt]//");
    grep $nf /tmp/$$local > /dev/null 2>&1;
    if test $? -eq 1
    then
        echo $f >> /tmp/$$deps;
    else
        echo "$(date) $f locally built package!";
    fi;
done;
for pack in $(cat /tmp/$$deps);
do
    PACKNAME=$(echo $pack|cut -f1 -d'='|sed -e"s/\[devel\]//"|sed -e"s/\%t/$TARGET/");
    VERPACK=$(echo $pack|cut -f2 -d'=');
    echo "$(date) Processing: $PACKNAME/$VERPACK";
# Compare version with already installed.
    VERINS=$(ropkg list-installed |grep -w $PACKNAME-devel|sed -e"s/\ -\ /#/"|cut -f2 -d'#');#echo "VERINS:("$VERINS")("$VERPACK")"
    if test "$VERINS" "=" "$VERPACK"
    then
      echo "$(date) Version already installed skipping";
    else
      ISCIB=$(echo $VERPACK|grep CIBUILDX);
      if test -z "$ISCIB"
      then
#regular pack
        REALPACK=$PACKNAME"-devel";
        FOLDER=$(grep Package:\ $REALPACK $SYSROOT/*|cut -f1 -d':');#echo "FOLDER:"$FOLDER;
        if ! test -z "$FOLDER"
        then
          FOLDER=$(echo $(basename $(grep Package:\ $REALPACK $SYSROOT/*|cut -f1 -d':'))|sed -e's/-int/\/int/');
          URL="http://"$packs"/"$FOLDER"/"$REALPACK"_"$VERPACK"_armv7h.ipk";
          URL2="http://"$packs"/"$FOLDER"/"$REALPACK"_"$VERPACK"_all.ipk";
          URL3="http://"$packstrunk"/"$PACKNAME"_"$VERPACK"_armv7h.ipk";
        else
          URL="";
        fi;
      else
#CI BUILD pack
        REALPACK=${REALPACK%"_"$TARGET};
        MAJORREV=$(echo $VERPACK|cut -f1 -d'.');#echo "MAJ:"$MAJORREV;
        MINORREV=$(echo $VERPACK|cut -f2 -d'.'|sed -e"s/CIBUILDX//"|sed -e"s/[0-9][0-9]$//");#echo "MIN:"$MINORREV;
        URL="http://"$cipacks""$MINORREV"/"$REALPACK"_"$MAJORREV"_"$TARGET"/"$REALPACK"_"$TARGET"-devel_"$VERPACK"_armv7h.ipk";
        URL2="http://"$cipacks""$MINORREV"/"$REALPACK"_"$MAJORREV"_service/"$REALPACK"-devel_"$VERPACK"_armv7h.ipk";
        URL3="";
      fi;
      if ! test -z "$URL"
      then
        echo "$(date) Downloading: $URL";
        wget $URL -P /tmp/$$setsys;
        if [ $? -ne 0 ]
        then
          wget $URL2 -P /tmp/$$setsys;
        fi;
        if [ $? -ne 0 ]
        then
          wget $URL3 -P /tmp/$$setsys;
          if [ $? -ne 0 ]
          then
            echo $pack >> $$nofound;
          fi;
        fi;
      fi;
    fi;
done;

if test -z "$ONLYD";
then 
  np=$(ls -l /tmp/$$setsys|wc -l);
  if test $np -gt 1
  then
    echo "$(date) Installing..";
    ropkg --force-reinstall --force-downgrade install /tmp/$$setsys/*;
  else
    echo "$(date) Nothing to install.";
  fi;
else
  mv /tmp/$$setsys ./$$cache;
fi;

#exit trap does clean-up
echo "$(date) done!";
exit 0;
