#!/usr/bin/bash
read -e -p "Introdu URL-ul urmarit (copy-paste din browser): " url
if [[ -z "$url" ]]; then
   printf '%s\n' "Lipsa informatie URL."
   exit 1
fi
read -p "Introdu un cuvant cheie, daca e necesar (ex. ips, rtx, wi-fi etc.): " kw
read -p "Introdu pretul maxim dorit (nr. intreg, default este 3000): " price
price=${price:-3000}
read -p "La cate secunde sa se faca refresh-ul (default este 10): " sec
sec=${sec:-10}
echo "Se pare ca azi cautam un pret mai mic de $price lei pentru" $(echo $url | cut -f4 -d "/" | tr "_" " ") in sectiunea $(echo $url | cut -f5 -d "/")". Refresh-ul rezultatelor se va face la fiecare $sec secunde."
while true
do
	curl -s $url | tr "," "\n" | grep -e "product_name&quot" -e "quot;price&quot" | awk 'NR%2{printf "%s ",$0;next;}1' | awk -v kw=$kw 'tolower($0) ~ tolower(kw)' | awk -F ";" '{print $4 "     " $NF}' | awk '{print $NF,$0}' | sort -u | sort -n | cut -f2- -d' ' | sed -e "s/&quot//" -e "s/u00ae//" -e "s/u2122//" -e "s/&#039//" | tr \\ " " 2>/dev/null | while read -r line
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
