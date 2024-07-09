#!/bin/bash

# sudo ./test.sh 51.103.132.74 10.240.0.0/16 159.122.127.115 10.194.22.192/26
#LOCAL_IP=51.103.132.74
#LOCAL_SUBNET=10.240.0.0/16
#REMOTE_IP=159.122.127.115
#REMOTE_SUBNET=10.194.22.192/26
LOCAL_IP=$1
LOCAL_SUBNET=$2
REMOTE_IP=$3
REMOTE_SUBNET=$4
SHARED_KEY=$5

apt update && apt upgrade -y
apt install strongswan -y

# update /etc/sysctl.conf
echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf

# update /etc/ipsec.secrets
echo "$LOCAL_IP $REMOTE_IP : PSK \"$SHARED_KEY\"" >> /etc/ipsec.secrets

# update /etc/ipsec.conf
echo "config setup" > /etc/ipsec.conf
echo "        charondebug=\"all\"" >> /etc/ipsec.conf
echo "        uniqueids=yes" >> /etc/ipsec.conf
echo "        strictcrlpolicy=no" >> /etc/ipsec.conf
echo "conn cloud-to-onprem" >> /etc/ipsec.conf
echo "        authby=secret" >> /etc/ipsec.conf
echo "        left=%defaultroute" >> /etc/ipsec.conf
echo "        leftid=$LOCAL_IP" >> /etc/ipsec.conf
echo "        leftsubnet=$LOCAL_SUBNET" >> /etc/ipsec.conf
echo "        right=$REMOTE_IP" >> /etc/ipsec.conf
echo "        rightsubnet=$REMOTE_SUBNET" >> /etc/ipsec.conf
echo "        keyexchange=ikev2" >> /etc/ipsec.conf
#echo "        ike=aes256-sha2_256-modp1024!" >> /etc/ipsec.conf
#echo "        esp=aes256-sha2_256!" >> /etc/ipsec.conf
echo "        keyingtries=0" >> /etc/ipsec.conf
echo "        ikelifetime=1h" >> /etc/ipsec.conf
echo "        lifetime=8h" >> /etc/ipsec.conf
echo "        dpddelay=30" >> /etc/ipsec.conf
echo "        dpdtimeout=120" >> /etc/ipsec.conf
echo "        dpdaction=restart" >> /etc/ipsec.conf
echo "        auto=start" >> /etc/ipsec.conf

iptables -t nat -A POSTROUTING -s $REMOTE_SUBNET -d $LOCAL_SUBNET -j MASQUERADE
ipsec restart

# tail -f /var/log/syslog