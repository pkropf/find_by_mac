#! /bin/bash

# https://maclookup.app/search/vendors/result?vendor=raspberry

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
  for mac in B8:27:EB 28:CD:C1 3A:35:41 D8:3A:DD DC:A6:32 E4:5F:01 28:CD:C1 3A:35:41 D8:3A:DD DC:A6:32 E4:5F:01
  do
    awker="/^Nmap/{ip=\$NF}/$mac/{print ip}"
    awk "$awker" < /tmp/find_rpi.nmap
  done
done
