#!/bin/sh -e
# $Header: /usersnfs/deantoni/common/bin/RCS/buildlux.sh,v 1.3 2016/08/02 11:59:07 deantoni Exp $

getScriptPath () {
  echo ${0%/*}/
}
TRZ=$HOME/buildlux_$USER.trz;
rm -f $TRZ 
PARAM=-i
PARAMMD=
# By default it goes to the same directory than when calling makedist from command line
DISTR=/sirius/work/dist__local_sirius_work_$USER;
LUX_BIN=$(getScriptPath)
ERRBUIL=
SKIP=0
YAML=/sirius/work/$USER/local_sirius_dist/lux_dist_bb1.yaml

source $(getScriptPath)/common.sh

while [ "$1" != "" ]; do
    case $1 in
        -c | --clean )          PARAM=$PARAM\ -C
                                PARAMMD=$PARAMMD\ --clean
                                echo "$(date) Rebuilding packs!!" 2>&1 | tee -a $TRZ;
                                ;;
        -f | --first )          PARAM=$PARAM\ -s
                                echo "$(date) First launch(check sysroot dependencies)!!" 2>&1 | tee -a $TRZ;
                                ;;
        -r | --sysroot )        shift
                                SYSROOT=$(absPath $1);
                                PARAM=$PARAM\ --root=$SYSROOT;
                                echo "$(date) SYSROOT in ["$SYSROOT"]" 2>&1 | tee -a $TRZ;
                                ;;
        -d | --distrib )        shift
                                DISTR=$(absPath $1);
                                echo "$(date) DISTR in ["$DISTR"]" 2>&1 | tee -a $TRZ;
                                ;;
        -y | --yaml )           shift
                                YAML=$(absPath $1);
                                echo "$(date) YAML in ["$YAML"]" 2>&1 | tee -a $TRZ;
                                ;;
        -i | --skip )           SKIP=1;
                                echo "$(date) skip local package build phase" 2>&1 | tee -a $TRZ;
                                ;;
        -t | --target )         shift
                                PARAM=$PARAM\ t=$1
                                PARAMMD=$PARAMMD\ --target\ $1
                                echo "$(date) TARGET " $TARGET 2>&1 | tee -a $TRZ;
                                ;;
        -h | --help )           echo "use: $0 [-r] [-d <distr folder>] [-y <distro yaml file>] [-t target]";
                                exit -1;
                                ;;
        * )                     echo "bad param!"$1;
                                exit -1
    esac
    shift
done

if ! test -z "$DISTR"
then
  PARAMMD=$PARAMMD\ --output\ $DISTR
fi;

grep "^local:" $YAML|sed -e"s/^local://" > /tmp/$$packs;
if ! test "$SKIP" -eq "1"
then
# extract packages to rebuild and rebuild them
  for record in $(cat /tmp/$$packs)
  do
      pack=$(echo $record|cut -f1 -d','|sed -e"s/ *//g");
      sandbox=$(echo $record|cut -f2 -d','|sed -e"s/ *//g");
      branch=$(echo $record|cut -f3 -d','|sed -e"s/ *//g");
      base=$(echo $record|cut -f4 -d','|sed -e"s/ *//g");
      skip=$(echo $record|cut -f5 -d','|sed -e"s/ *//g");
      if test -z "$skip"
      then
        echo "$(date) building pack:$pack on branch:$branch ($sandbox) (base:$base)" 2>&1 | tee -a $TRZ;
        if ! test -d "$sandbox/opkgbuild/$pack"
        then
            echo "$(date) $sandbox/opkgbuild/$pack doesnt exist" 2>&1|tee -a $TRZ;
            ERRBUIL=1;
        else
          cd $sandbox/opkgbuild/$pack;
#check sha base
          real_base=$(git merge-base origin/trunk $branch);
          if ! test "$base" == "$real_base"
          then
            echo "$(date): [$branch] base sha doesnt match (rebase needed) ($base vs. $real_base)" 2>&1 | tee -a $TRZ;
            ERRBUIL=1;
          else
            git checkout $branch;
            if ! test $? -eq 0
            then
              echo "$(date): $branch doesnt exist!" 2>&1 | tee -a $TRZ;
              ERRBUIL=1;
            else
              rm -f *.ipk;
              /sirius/tools2/bin/makepkg $PARAM > $TRZ;
              if ! test $? -eq 0
              then
                echo "$(date): error building package $pack!" 2>&1 | tee -a $TRZ;
                ERRBUIL=1;
              fi;
            fi;
          fi;
        fi;
      else
        echo "$(date) skip pack:$pack on branch:$branch ($sandbox) (base:$base)" 2>&1 | tee -a $TRZ;
      fi;
  done;
fi;

# patch distro receipt file so it points to local built packages and rebuild it.
if test -z "$ERRBUIL"
then
cat > /tmp/$$patch_dist.awk << EOF
  BEGIN {
    FS="";
    i=1;
    while (getline < file)
    {
      split(\$0,ft,",");
      packs[i]=ft[1];
      sandbox[i]=ft[2];
      gsub(" ","",packs[i]);
      gsub(" ","",sandbox[i]);
      i++;
    }
  }
  {
    for(j=1;j<i;j++)
    {
      if(index(\$0,packs[j]))
      {
        sub("=.*$","="sandbox[j]"/opkgbuild/"packs[j],\$0);
      }
    }
    print \$0;
  }
EOF
  NYAML=$(dirname $YAML)/mydist.yaml; # new name cannot contain $$ or it build rebuild the entire thing each time
  awk -v file=/tmp/$$packs -f /tmp/$$patch_dist.awk $YAML > $NYAML;
  echo "$(date): rebuild distro" 2>&1 | tee -a $TRZ;
  /sirius/tools/bin/makedist $PARAMMD $NYAML 2>&1 | tee -a $TRZ;
  echo "$(date): rebuild distro done" 2>&1 | tee -a $TRZ;
else
  echo "$(date): sikipping rebuild distro, errors building local packages." 2>&1 | tee -a $TRZ;
fi;

# Cleansing automatic (common.sh)
echo "$(date): end" 2>&1 | tee -a $TRZ;
exit 0;
