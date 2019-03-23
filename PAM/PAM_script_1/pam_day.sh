#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

DAY=`date +"%u"`
MDAY=`date +"%d%m"`

if [[ $DAY == "6" || $DAY == "7" ]]
then
#  echo "Hey, it's weekend! Go home!"
  exit 12
elif [[ $MDAY == "0101" || $MDAY == "0803" || $MDAY == "2302" || $MDAY == "0105" || $MDAY == "0905" ]]
then
#  echo "Hey! Today is holiday! Go HOME!"
  exit 11
else
#  echo "OK, today's work day. Go and work!"
  exit 0
fi
