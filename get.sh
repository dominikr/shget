#!/bin/sh
# TODO:
# -more portable echo/printf
# -IPv6
# -proxy support

url=`echo $1|sed 's/^http:\/\///'`
host=`echo $url|sed 's/\/.*$//'`
uri=`echo $url|sed 's/^[^\/]\{1,\}//'`
if [ -z "$uri" ]
then
	uri='/'
fi

port=80
if echo "$host"|grep ":[0-9]\{1,5\}" >/dev/null
then
	port=`echo $host|sed 's/^.*://'`
	host=`echo $host|sed 's/:[0-9]*$//'`
fi

echo -e "GET $uri HTTP/1.0\r"
echo -e "Host: $host\r"
echo -e "Connection: close\r"
echo -e "User-Agent: shget\r"
echo -e "\r"
