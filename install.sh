#!/bin/bash
shopt -s expand_aliases


# Function to check to see if a command exists on the computer.
exists()
{
	command -v "$1" >/dev/null 2>&1
}

# Set up our dsh script as a local executable file.
if ! exists dsh; then
	echo "Adding dsh binary to the path."
	PATH=$PATH:$(pwd)/bin/
else
	echo "DSH command exists. Continuing with installation."
fi


# Download dependent container images.
# if exists docker; then
	# docker pull node
	# docker pull mongo
# else
#	echo "Error: `docker` command not found. Aborting install now. Run this script again after installing Docker."
#	exit 1;
# fi


# Install our box and set up the IP in /etc/hosts.
if exists docker-compose; then
	dsh up
	# dsh reload
else
	echo "Error: `docker-machine` command not found. Aborting install now. Run this script again after installing Docker."
	exit 1;
fi


# Set the IP route in /etc/hosts on the host machine.
HOSTFILE="/etc/hosts"
if ! grep --quiet "crispy.docker" "$HOSTFILE"; then
	echo "Adding DNS to hosts file for crispy.docker."
    sudo cp "$HOSTFILE" "$HOSTFILE".bak
	sudo -- sh -c -e "echo '\n# Bacon is Crispy...\n127.0.0.1\tcrispy.docker www.crispy.docker' >> /etc/hosts"
	dscacheutil -flushcache
else
	echo "DNS information for crispy.docker exists in hosts file. Continuing with installation."
fi


# We're done!
echo "Installation complete! Type 'dsh st' to verify that the docker machine is running."