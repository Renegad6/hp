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
export ignorefiles="tags rrsync rebtags"

export SSH_OPTIONS=" -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o PasswordAuthentication=no "

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

function newest_matching_file
{
    # Use ${1-} instead of $1 in case 'nounset' is set
    local -r glob_pattern=${1-}

    if (( $# != 1 )) ; then
        echo 'usage: newest_matching_file GLOB_PATTERN' >&2
        return 1
    fi

    # To avoid printing garbage if no files match the pattern, set
    # 'nullglob' if necessary
    local -i need_to_unset_nullglob=0
    if [[ ":$BASHOPTS:" != *:nullglob:* ]] ; then
        shopt -s nullglob
        need_to_unset_nullglob=1
    fi

    newest_file=
    for file in $glob_pattern ; do
        [[ -z $newest_file || $file -nt $newest_file ]] \
            && newest_file=$file
    done

    # To avoid unexpected behaviour elsewhere, unset nullglob if it was
    # set by this function
    (( need_to_unset_nullglob )) && shopt -u nullglob

    # Use printf instead of echo in case the file name begins with '-'
    [[ -n $newest_file ]] && printf '%s\n' "$newest_file"

    return 0
}

export n=0;
function getfile()
{
    echo /tmp/$$temp.$n;
    export n=$((n + 1));
}
