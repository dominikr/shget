#!/bin/sh

my_ppid=$1

read status
echo $status
http=`echo $status|sed 's/^\(.....\).*/\1/'`
if [ "x$http" != "xHTTP/" ]
then
	echo "No HTTP response"
	exit 1
fi

code=`echo $status|sed 's/^[^ ]* \(...\) .*/\1/'`
echo "HTTP Status code: $code"

if [ "$code" -ne 200 ]
then
	echo "Something went wrong, didn't get code 200"
	exit 1
fi

while read foo
do
	if echo $foo | grep -i "^content-length" >/dev/null
	then
		length=`echo "$foo"|sed 's/^.*: *//'`
		echo "length $length"
	fi

	len=`expr length "$foo"`
	if test $len -eq 1 -o $len -eq 0
	then
		if [ -n "$length" ]
		then
			dd of=out bs=1 count=$length 2> /dev/null
		else
			dd of=out 2> /dev/null
		fi
		str="$my_ppid$"
		#echo $str
		pid=`ps -af|grep "sleep 80$"|awk '{print $2 " " $3}'|grep "$str"|awk '{print $1}'`
		#echo $pid
		kill $pid
	fi

done
