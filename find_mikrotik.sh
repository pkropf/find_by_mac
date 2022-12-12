#! /bin/bash

# mac addresses from https://maclookup.app/search/vendors/result?vendor=routerboard

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
  for mac in 00:0C:42 08:55:31 18:FD:74 2C:C8:1B 48:8F:5A 48:A9:8A 4C:5E:0C 64:D1:54 6C:3B:6B 74:4D:28 B8:69:F4 C4:AD:34 CC:2D:E0 D4:CA:6D DC:2C:6E E4:8D:8C 
  do
    awker="/^Nmap/{ip=\$NF}/$mac/{print ip}"
    awk "$awker" < /tmp/find_rpi.nmap
  done
done
