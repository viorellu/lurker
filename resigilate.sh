#!/usr/bin/bash
while true
do
curl -s https://www.emag.ro/placi_video/resigilate/c?ref=lst_leftbar_6407_resealed | grep -i rtx | tr "," "\n" | grep -e "product_name&quot" -e "quot;price&quot" | awk 'NR%2{printf "%s ",$0;next;}1' | awk -F ";" '{print $4 "     " $6}' | sed "s/&quot//" | sed "s/u00ae//" | sed "s/u2122//" | tr \\ " " 2>/dev/null | while read -r line
do
p=$(echo $line | cut -f 2 -d ":" | cut -f1 -d ".")
        if [ $p -gt 3000 ]
                then
                        echo `date +"%d.%h.%y %H:%M:%S"` "Bad price found for" $line
                else
                        msum=$(echo -n $line | md5sum | awk '{print $1}')
                        if [ $(grep -c $msum resigilate.log) == 0 ]
                                then
                                        echo `date +"%d.%h.%y %H:%M:%S"` $msum $line >>resigilate.log
                                        curl -s -F "token=yourAppTokenHere" -F "user=yourUserTokenHere" -F "title=yourTitle" -F "message=Price alert for $line at `date +"%d.%h.%y %H:%M:%S"`" https://api.pushover.net/1/messages.json
                                        echo -n $'\a'
                                        sleep 1
                                        echo $'\a' `date +"%d.%h.%y %H:%M:%S"` "Good price found for" $line
                                        sleep 1
                                        echo -n $'\a'
                                else
                                        echo `date +"%d.%h.%y %H:%M:%S"` "Good price still available for" $line
                        fi
        fi
done
echo =======================================
sleep 300
done
