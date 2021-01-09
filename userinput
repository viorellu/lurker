#!/usr/bin/bash
read -e -p "Insert your URL (copy-paste from browser): " url
if [[ -z "$url" ]]; then
   printf '%s\n' "No URL present."
   exit 1
fi
read -p "Insert  kwyword, if necessry (ex. ips, rtx, wi-fi etc.): " kw
read -p "Your target price (INT number, default is 3000): " price
price=${price:-3000}
read -p "Price polling refresh interval in seconds (default is 10): " sec
sec=${sec:-10}
echo "Looks like we're looking for a price lower than $price RON for" $(echo $url | cut -f4 -d "/" | tr "_" " ") within the section $(echo $url | cut -f5 -d "/")". The results will refresh every $sec sec."
while true
do
    curl -s $url | tr "," "\n" | grep -e "product_name&quot" -e "quot;price&quot" | awk 'NR%2{printf "%s ",$0;next;}1' | awk -v pat="$kw" 'BEGIN {IGNORECASE = 1} $0 ~ pat' | awk -F ";" '{print $4 "     " $NF}' | awk '{print $NF,$0}' | sort -n | sort -u |cut -f2- -d' ' | sed "s/&quot//" | sed "s/u00ae//" | sed "s/u2122//" | sed "s/&#039//" | tr \\ " " 2>/dev/null | while read -r line
    do
         p=$(echo $line | cut -f 2 -d ":" | cut -f1 -d ".")
         if [ $p -gt $price ]
             then
                  echo `date +"%d.%h.%y %H:%M:%S"` "Bad price found for" $line
             else
                  echo `date +"%d.%h.%y %H:%M:%S"` "Good price found for" $line
           fi
      done | sort -k3
echo =======================================
sleep $sec
done
