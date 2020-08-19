# Sends email through aws cli
# $1: username of the account to be registered

#!/bin/bash
set -e

if [ -z "$1" ]
then
    echo "Enter attachment filename as \$1"
    exit
fi

FILEPATH=$1
echo "Sending \"$(basename $FILEPATH)\" as email attachment..."

FROM=my0p3nvpn@gmail.com
TO=valerio.ferretti92@gmail.com
SUBJECT="myopenvpn registration"
BODY='<html><head></head><body><h3>Hello Valerio,</h3><p>the setup of your new user was completed successfully. It is time for you to enjoy your own (and long awaited) VPN server!</p><p>Have fun and keep on learning :-)</p></body></html>'

TEMPLATE_DATA='From: {FROM}\nTo: {TO}\nSubject: {SUBJECT}\nMIME-Version: 1.0\nContent-type: Multipart/Mixed; boundary="NextPart"\n\n--NextPart\nContent-Type: text/html\nContent-Transfer-Encoding: base64\n\n{BODY}\n\n--NextPart\nContent-Type: text/plain;\nContent-Disposition: attachment; filename="{FILENAME}"\nContent-Transfer-Encoding: base64\n\n{ATTACHMENT}\n\n--NextPart--'
echo -e $TEMPLATE_DATA >> template-data.txt
sed -i -e "s/{FROM}/$FROM/g" template-data.txt
sed -i -e "s/{TO}/$TO/g" template-data.txt
sed -i -e "s/{SUBJECT}/$SUBJECT/g" template-data.txt
sed -i -e "s/{BODY}/$(echo "$BODY" | base64 -w 0)/g" template-data.txt
sed -i -e "s/{FILENAME}/$(basename $FILEPATH)/g" template-data.txt
sed -i -e "s/{ATTACHMENT}/$(cat $FILEPATH | base64 -w 0)/g" template-data.txt
echo -e "\nTEMPLATE DATA:"
cat template-data.txt

TEMPLATE='{"Data": "{TEMPLATE_DATA}"}'
echo $TEMPLATE >> template.txt
sed -i -e "s/{TEMPLATE_DATA}/$(cat template-data.txt | base64 -w 0)/g" template.txt
echo -e "\nTEMPLATE:"
cat template.txt

aws ses send-raw-email --raw-message file://template.txt --region us-east-1

rm template-data.txt
rm template.txt
