#! /bin/bash

# mac addresses from https://maclookup.app/vendors/ubiquiti-networks-inc

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
  for mac in 00:15:6D 00:27:22 00:50:C2:B0:4 04:18:D6 18:E8:29 24:5A:4C 24:A4:3C 44:D9:E7 60:22:32 68:72:51 \
		      68:D7:9A 70:A7:41 74:83:C2 74:AC:B9 78:45:58 78:8A:20 80:2A:A8 94:2A:6F AC:8B:A9 B4:FB:E4 \
		      D0:21:F9 DC:9F:DB E0:63:DA E4:38:83 F0:9F:C2 F4:92:BF F4:E2:C6 FC:EC:DA
  do
    awker="/^Nmap/{ip=\$NF}/$mac/{print ip}"
    awk "$awker" < /tmp/find_rpi.nmap
  done
done


