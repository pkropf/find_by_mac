#! /bin/bash

# mac addresses from https://maclookup.app/vendors/ubiquiti-networks-inc

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ $# -eq 0 ]
then
    echo "need to provide file with list of mac address prefixes to search"
    exit 1
fi

macs="$1"

if [ $# -gt 1 ]
then
    shift 1
    nets="$@"
else
    nets=`ip route | grep -v default | grep -v Kernel | grep -v Destination | grep -v link-local | cut -d' ' -f 1`
fi

for NET in $nets
do
  echo searching $NET
  nmap -sP $NET > /tmp/find_rpi.nmap
  for mac in `cat $macs`
  do
    awker="/^Nmap/{ip=\$NF}/$mac/{print \"$mac \" ip}"
    awk "$awker" < /tmp/find_rpi.nmap
  done
done
