#!/bin/bash

usage()
{
    echo "Usage:"
    echo "$0 apply <IP>"
    echo "$0 remove <IP>"
    exit 1
}

if [ $# -ne 2 ]
then
    usage
fi

IP=$2

case $1 in
    apply)
        ssh -o "StrictHostKeyChecking=no" -l root $IP 'echo "# remove snd_hda_intel driver because it prevents the machine to power off" > /etc/rc3.d/S01removeSound'
        ssh -o "StrictHostKeyChecking=no" -l root $IP 'echo "# temporary hack for testing" >> /etc/rc3.d/S01removeSound'
        ssh -o "StrictHostKeyChecking=no" -l root $IP 'echo "rm /lib/modules/*/kernel/sound/pci/hda/snd-hda-intel.ko " >> /etc/rc3.d/S01removeSound'
        ssh -o "StrictHostKeyChecking=no" -l root $IP 'chmod 755 /etc/rc3.d/S01removeSound'
    ;;
    remove)
        ssh -o "StrictHostKeyChecking=no" -l root $IP rm /etc/rc3.d/S01removeSound
    ;;

    *)
    usage
    ;;
esac
