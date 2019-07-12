#!/bin/bash
WORD=$1
LOG=$2
DATE=`date`
if grep $WORD $LOG &> /dev/null
then
echo "$DATE: I found word, Master!" >> /opt/log
else
exit 0
fi

