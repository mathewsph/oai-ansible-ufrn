#!/bin/sh
iptables -A INPUT -s 12.1.1.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -s 192.168.70.128/26 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j DROP