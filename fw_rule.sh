#!/bin/sh
CHAIN_NAME=REJECT_IP
BLOCK_IP=$(grep Invalid /var/log/secure | awk '{print $10}' | sort | uniq)

for i in $BLOCK_IP
do
   # check loop
   # echo $i
   # check dup ip
   iptables -nL $CHAIN_NAME | grep $i > /dev/null 2>&1
   ret_value=$?
   [ $ret_value -eq 0 ] && continue
   # add ip
   iptables -I $CHAIN_NAME -s $i -j REJECT
done
