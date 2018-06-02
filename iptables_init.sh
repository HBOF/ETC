#!/bin/sh
#install iptables & disablefirewalld
cd ~
echo 'now iptables is intalling...'
yum -y install iptables*
echo 'now iptables is intalled!'
systemctl stop firewalld
systemctl disable firewalld
systemctl enable iptables
systemctl enable iptables
systemctl start iptables

#insert log param
modprobe nf_log_ipv4
sysctl net.netfilter.nf_log.2=nf_log_ipv4
echo 'kern.* /var/log/iptables.log' >> /etc/rsyslog.conf
#echo 'kern.*;*.info;mail.none;authpriv.none;cron.none                /var/log/messages' >> /etc/rsyslog.conf
echo 'now rsyslog is restarting...'
systemctl restart rsyslog
echo 'now rsyslog is started! now iptables is loging at /var/log/iptables.log'
echo '5'
sleep 1
echo '4'
sleep 1
echo '3'
sleep 1
echo '2'
sleep 1
echo '1'
sleep 1

#init iptables
echo 'now iptables is restarting...'
systemctl restart iptables
echo 'now iptables is started!'
iptables -F
iptables -N ACCEPT_IP
iptables -N REJECT_IP
iptables -A INPUT -j ACCEPT_IP
iptables -A ACCEPT_IP -j REJECT_IP
#iptables default
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -m state --state NEW -m tcp --dport 22 -j ACCEPT
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
iptables -t raw -nL
sleep 1
echo 'now 3306 port is traceing...'
sleep 1 
echo 'iptables -t raw -j TRACE -p tcp --dport 3306 -I PREROUTING 1'
iptables -t raw -j TRACE -p tcp --dport 3306 -I PREROUTING 1
echo 'iptables -t raw -j TRACE -p tcp --dport 3306 -I OUTPUT 1'
iptables -t raw -j TRACE -p tcp --dport 3306 -I OUTPUT 1
iptables -t raw -nL
sleep 1
#echo 'now not logging if samepacket is coming...'
#sleep 1 
#iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " 
echo 'now saving iptables...'
service iptables save
echo 'now saved iptables!'