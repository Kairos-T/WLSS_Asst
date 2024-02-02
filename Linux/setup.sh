#!/bin/bash

# Check for sudo permissions
if [ "$EUID" -ne 0 ]
  then echo "Please run this script as root!"
  exit
fi

# Install USBGuard
yum install usbguard -y

# Create initial rule set
echo "Creating initial rule set..."
usbguard generate-policy > /rules.conf

# Enable and start USBGuard
echo "Enabling and starting USBGuard..."
systemctl start usbguard.service

# Enable USBGuard on boot
echo "Enabling USBGuard on boot..."
systemctl enable usbguard.service

# Check status of USBGuard
echo "Checking status of USBGuard..."
systemctl is-active --quiet usbguard.service && echo "USBGuard is active." || echo "USBGuard is not active."

# Create default ruleset to block all new USB devices
echo "Creating default ruleset to block all new USB devices..."
echo block >> /rules.conf

# Load the new ruleset
#usbguard read-policy /etc/usbguard/rules.conf
#usbguard reload
echo "Loading new ruleset..."
install -m 0600 -o root -g root /rules.conf /etc/usbguard/rules.conf 

# Inform user of completion
echo "USBGuard has been installed and configured."