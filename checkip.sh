#!/bin/bash
# Script to provide IP Address score as per projecthoneypot
# Input your HTTP:bl API Key from the site in the "KEY" field below:

KEY='';
SUFFIX="dnsbl.httpbl.org";
echo "Enter IP Address:";
read IPADDRESS;
REVERSEIP=$(echo "$IPADDRESS" | awk -F. '{print $4"."$3"."$2"."$1}');
RESULT=$(eval $echo "dig +short $KEY"."$REVERSEIP"."$SUFFIX");
if [[ -z "$RESULT" ]]; then
        echo "IP Address is Clean as per ProjectHoneyPot";
        exit;
fi

# 2nd Octet Provides the no. of days back the IP Address was seen by ProjectHoneyPot
LASTSEEN=$(echo $RESULT | awk -F. '{print $2}');
echo "Last Seen = $LASTSEEN days back!";

# 4th Octet Provides the Category
CATEGORYOCTET=$(echo $RESULT | awk -F. '{print $4}');
if [[ $CATEGORYOCTET -eq 0 ]]; then
        CATEGORY=SearchEngine;
elif [[ $CATEGORYOCTET -eq 1 ]]; then
        CATEGORY=Suspicious;
elif [[ $CATEGORYOCTET -eq 2 ]]; then
        CATEGORY=Harvester;
elif [[ $CATEGORYOCTET -eq 4 ]]; then
        CATEGORY=CommentSpammer;
fi
echo "Category = $CATEGORY";

# 3rd Octet provides the Threat Score or the Search Engine Name if Category is Search Engine
SCORE=$(echo $RESULT | awk -F. '{print $3}');
if [[ $CATEGORYOCTET -eq 0 ]]; then
	if [[ $SCORE -eq 0 ]]; then
		SEARCHENGINE=Undocumented;
	elif [[ $SCORE -eq 1 ]]; then
		SEARCHENGINE=AltaVista;
	elif [[ $SCORE -eq 2 ]]; then
		SEARCHENGINE=Ask;
	elif [[ $SCORE -eq 3 ]]; then
		SEARCHENGINE=Baidu;
	elif [[ $SCORE -eq 4 ]]; then
		SEARCHENGINE=Excite;
	elif [[ $SCORE -eq 5 ]]; then
		SEARCHENGINE=Google;
	elif [[ $SCORE -eq 6 ]]; then
		SEARCHENGINE=Looksmart;
	elif [[ $SCORE -eq 7 ]]; then
		SEARCHENGINE=Lycos;
	elif [[ $SCORE -eq 8 ]]; then
		SEARCHENGINE=MSN;
	elif [[ $SCORE -eq 9 ]]; then
		SEARCHENGINE=Yahoo;
	elif [[ $SCORE -eq 10 ]]; then
		SEARCHENGINE=Cuil;
	elif [[ $SCORE -eq 11 ]]; then
		SEARCHENGINE=InfoSeek;
	elif [[ $SCORE -eq 12 ]]; then
		SEARCHENGINE=Miscellaneous;
	fi
	echo "Search Engine Name = $SEARCHENGINE";
else
	echo "Threat Score = $SCORE"
fi