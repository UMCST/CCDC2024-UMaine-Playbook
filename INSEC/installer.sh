#!/bin/bash

if [ $# -eq 0 ]; then
	echo "usage: ./installer.sh server_name/ip_address [version]"
	exit 1
fi

# i386		| i386
# x86_64	| amd64
# armhf		| armhf
# aarch64	| arm64
if command -v apt &> /dev/null; then
	if dpkg -l | grep -q "^ii\s*wazuh-agent\s"; then
		sudo dpkg --purge wazuh-agent
	fi
	wget -O wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_${2:-4.7.1-1}_amd64.deb || { echo "Error downloading Wazuh agent."; exit 1; }
	sudo WAZUH_MANAGER="$1" dpkg -i ./wazuh-agent.deb || { echo "Error installing Wazuh agent. TELL ETHAN OR SAM THAT THIS HAPPENED."; exit 1; }
	rm wazuh-agent.deb

# i386 		| i386
# x86_64 	| x86_64 (default)
# armhf 	| armv7h1
# aarch64 	| aarch64
# PowerPC 	| ppc64le
elif command -v yum &> /dev/null; then
	if yum list installed "wazuh-agent" &> /dev/null; then
		sudo yum remove wazuh-agent -y
	fi	
	sudo WAZUH_MANAGER="$1" yum install -y https://packages.wazuh.com/4.x/yum/wazuh-agent-${2:-4.7.1-1}.x86_64.rpm
else
	echo "unrecognized operating system or distribution"
fi
sudo systemctl daemon-reload
sudo systemctl enable wazuh-agent
sudo systemctl start wazuh-agent
