#!/bin/bash
# install.sh
# Installs masternode on Ubuntu 16.04 x64 & Ubuntu 18.04
# ATTENTION: The anti-ddos part will disable http, https and dns ports.


if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi
# Create a cronjob for making sure geekcashd runs after reboot
if ! crontab -l | grep "@reboot geekcashd"; then
  (crontab -l ; echo "@reboot geekcashd") | crontab -
fi

# Create a cronjob for making sure geekcashd is always running
if ! crontab -l | grep "~/geekcash/makerun.sh"; then
  (crontab -l ; echo "*/5 * * * * ~/geekcash/makerun.sh") | crontab -
fi

# Create a cronjob for clearing the log file
if ! crontab -l | grep "~/geekcash/clearlog.sh"; then
  (crontab -l ; echo "0 0 */2 * * ~/geekcash/clearlog.sh") | crontab -
fi

# Give execute permission to the cron scripts
chmod 0700 ./makerun.sh
chmod 0700 ./clearlog.sh

# Start GeekCash Deamon
geekcashd

# Reboot the server
#reboot