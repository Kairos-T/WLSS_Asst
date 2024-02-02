#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check for sudo permissions
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run this script as root!${NC}"
  exit
fi

# Install USBGuard
echo -e "${GREEN}Installing USBGuard...${NC}"
yum install usbguard -y

# Create initial rule set
echo -e "${GREEN}Creating initial rule set...${NC}"
usbguard generate-policy > /rules.conf

# Enable and start USBGuard
echo -e "${GREEN}Enabling and starting USBGuard...${NC}"
systemctl start usbguard.service

# Enable USBGuard on boot
echo -e "${GREEN}Enabling USBGuard on boot...${NC}"
systemctl enable usbguard.service

# Check status of USBGuard
echo -e "${GREEN}Checking status of USBGuard...${NC}"
systemctl is-active --quiet usbguard.service && echo -e "${GREEN}USBGuard is active.${NC}" || echo -e "${RED}USBGuard is not active.${NC}"

# Create default ruleset to block all new USB devices
echo -e "${GREEN}Creating default ruleset to block all new USB devices...${NC}"
echo block >> /rules.conf

# Load the new ruleset
echo -e "${GREEN}Loading new ruleset...${NC}"
install -m 0600 -o root -g root /rules.conf /etc/usbguard/rules.conf 

# Inform user of completion
echo -e "${GREEN}USBGuard has been installed and configured.${NC}"