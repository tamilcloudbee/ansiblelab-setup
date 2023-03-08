#!/usr/bin/env bash

set -x

sudo -i

apt update -y
apt install whois -y

USERNAME="automation"
PASS=$(mkpasswd --hash=SHA-512 $USERNAME)
ADD_USERTO_SUDOERS="$USERNAME ALL=(ALL) NOPASSWD:ALL"
FILE_SUDOERS="/etc/sudoers"
FILE_SSHDCONFIG="/etc/ssh/sshd_config"

useradd $USERNAME -m -d /home/$USERNAME -p $PASS -s /bin/bash
if [ ! -f /etc/sudoers.bak ]
then
  cp  $FILE_SUDOERS /etc/sudoers.bak
fi

if  ! grep "$ADD_USERTO_SUDOERS" $FILE_SUDOERS
then
  echo "$ADD_USERTO_SUDOERS" >> $FILE_SUDOERS
fi

if [ ! -f /etc/ssh/sshd_config.bak ]
then
  cp  $FILE_SSHDCONFIG /etc/ssh/sshd_config.bak
fi

sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config

sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

systemctl restart sshd
systemctl enable sshd


