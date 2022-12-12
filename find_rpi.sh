#! /bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [ $# -gt 0 ]
then
    nets="$@"
else
    nets=`ip route | grep -v default | grep -v Kernel | grep -v Destination | grep -v link-local | cut -d' ' -f 1`
fi

for NET in $nets
do
  echo searching $NET
  nmap -sP $NET > /tmp/find_rpi.nmap
  for mac in B8:27:EB DC:A6:32
  do
    awker="/^Nmap/{ip=\$NF}/$mac/{print ip}"
    awk "$awker" < /tmp/find_rpi.nmap
  done
done
