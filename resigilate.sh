#!/usr/bin/bash
touch resigilate.log
touch resigilate.mail
while true
do
curl -s https://www.emag.ro/placi_video/resigilate/c?ref=lst_leftbar_6407_resealed | tr "," "\n" |  grep -e "product_name&quot" -e "quot;price&quot" | awk 'NR%2{printf "%s ",$0;next;}1' | awk -F ";" '{print $4 "     " $NF}' | awk '{print $NF,$0}' | sort -n | cut -f2- -d' ' | sed "s/&quot//" | sed "s/u00ae//" | sed "s/u2122//" | tr \\ " " 2>/dev/null | grep -i rtx| while read -r line
do
p=$(echo $line | cut -f 2 -d ":" | cut -f1 -d ".")
        if [ $p -gt 3000 ]
                then
                        echo `date +"%d.%h.%y %H:%M:%S"` "Bad price found for" $line
                else
                        msum=$(echo -n $line | md5sum | awk '{print $1}')
                        if [ $(grep -c $msum resigilate.log) == 0 ]
                                then
                                        echo From: \"lurker\" >resigilate.mail
                                        echo To: \"myemailaddress\" >>resigilate.mail
                                        echo Subject: This is a price alert from the EMAG lurker >>esigilate.mail
                                        echo "" >>resigilate.mail
                                        echo `date +"%d.%h.%y %H:%M:%S"` $msum $line | tee -a resigilate.log resigilate.mail >/dev/null
                                        echo -n $'\a'
                                        sleep 1
                                        echo $'\a' `date +"%d.%h.%y %H:%M:%S"` "Good price found for" $line
                                        sleep 1
                                        echo -n $'\a'
#Push notification section using pushover API
                                        curl -s -F "token=YourAppTokenHere" -F "user=YourUserTokenHere" -F "title=AppNameOrWhatever" -F "message=Price alert for $line at `date +"%d.%h.%y %H:%M:%S"`" https://api.pushover.net/1/messages.json
#Send email using curl, password is 
#in CLEARTEXT so use an application 
#password instead, if supported
                                        curl -s -n --ssl-reqd --mail-from "EmailSending@Addres.Com" --mail-rcpt "ReceivingEmail@Adress.Com" --url <smtps://smtp.server.com:port> -u 'EmailSending@Addres.Com:EmailPassword' --upload-file resigilate.mail 1>/dev/null 2>&1
                                else
                                        echo `date +"%d.%h.%y %H:%M:%S"` "Good price still available for" $line
                        fi
        fi
done
echo =======================================
sleep 300
done
