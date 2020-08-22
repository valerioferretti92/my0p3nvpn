# Sends email through aws cli
# $1: username of the account to be registered

#!/bin/bash
set -e

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Enter target email as \$1 and attachment file path as \$2"
    exit
fi

FROM=my0p3nvpn@gmail.com
TO=$1
SUBJECT="myopenvpn registration"
BODY='<html><head></head><body><h3>Hello Valerio,</h3><p>the setup of your new user was completed successfully. It is time for you to enjoy your own (and long awaited) VPN server!</p><p>Have fun and keep on learning :-)</p></body></html>'
FILEPATH=$2

echo "Sending \"$(basename $FILEPATH)\" as email attachment..."

RAW_EMAIL_DATA="From: $FROM\nTo: $TO\nSubject: $SUBJECT\nMIME-Version: 1.0\nContent-type: Multipart/Mixed; boundary=\"NextPart\"\n\n--NextPart\nContent-Type: text/html\nContent-Transfer-Encoding: base64\n\n$(echo "$BODY" | base64 -w 0)\n\n--NextPart\nContent-Type: text/plain;\nContent-Disposition: attachment; filename=\"$(basename $FILEPATH)\"\nContent-Transfer-Encoding: base64\n\n$(cat $FILEPATH | base64 -w 0)\n\n--NextPart--"
echo -e "\nRAW EMAIL DATA (before base64 encoding):"
echo -e $RAW_EMAIL_DATA
echo "{\"Data\": \"$(echo -e $RAW_EMAIL_DATA | base64 -w 0)\"}" >> rawemail.txt

aws ses send-raw-email --raw-message file://rawemail.txt --region us-east-1
rm rawemail.txt
