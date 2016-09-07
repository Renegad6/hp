#Common definitios for scripts 
getScriptPath () {
  echo ${0%/*}/
}
timestamp () {
  echo $((`date +%s`*1000+`date +%-N`/1000000));
}
export PATH=/sirius/tools2/bin:/sirius/tools/bin:$PATH;
export FTP_PROXY=http://proxy-ccy.houston.hp.com:8080
export HTTPS_PROXY=http://proxy-ccy.houston.hp.com:8080
export HTTP_PROXY=http://proxy-ccy.houston.hp.com:8080
export ftp_proxy=http://proxy-ccy.houston.hp.com:8080
export http_proxy=http://proxy-ccy.houston.hp.com:8080
export https_proxy=http://proxy-ccy.houston.hp.com:8080
export no_proxy=hp.com,127.0.0.1,localhost,hpicorp.net
export packs=nebula.vcd.hp.com/packages
export packstrunk=nebula.vcd.hp.com/packages/trunk_pkgs/int
export cipacks=rndapp2.sdd.hp.com/ci_builds/sirius_trunk_mpkg_monitor/sirius_trunk_mpkg_monitor

absPath () {
    if [[ "$1" =~ ^/ ]]
    then
      echo $1;
    else
      echo $PWD/$1;
    fi;
}

trap ctrl_c INT
trap finish EXIT

function clean(){
  rm -rf /tmp/$$*;
}

function ctrl_c(){
    echo "** CtrlC!!"
    exit -1;
}

function finish(){
    echo "** Bye!!"
    clean;
}
