#!/bin/bash

trap "exit" SIGINT
trap "exit" SIGTERM

HOST=$(hostname)
USER=${USER:-root}
PASS=${PASS:-1234}

echo "$USER:$PASS" | chpasswd > /dev/null 2>&1
echo -e "pts/0\npts/1\npts/2\npts/3\npts/4\npts/5\npts/6\npts/7" >> /etc/securetty # to login as root on telnet

IP=$(ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')

echo "$HOST :: A telnetd is running at $IP:23"
echo "$HOST :: User: $USER, Password: $PASS"

telnetd # "-F" for run in foreground

while true
do
    sleep 1
    # tail -f /dev/null & wait ${!}
    # ps -ef
done

# tail -f /var/log
