#!/bin/sh
# Checks the connection of a given interface to a network and to the internet

if [ $# == 1 ]; then
	INTERFACE=$1
	# Check if interface is known
	if [ -f /sys/class/net/$INTERFACE/carrier ]; then
		# Interface is known
		NETWORK=`cat /sys/class/net/$INTERFACE/carrier`
		if [ $NETWORK == 0 ]; then
			# No connection to any network on this interface
			echo "0"
		elif [ $NETWORK == 1 ]; then
			# Connected to network - check internet connection
			INTERNET=`ping -q -w1 -c 1 1.1.1.1 &>/dev/null && echo 2 || echo 1`
			echo $INTERNET
		fi
	else
		# Interface unknown
		echo "-1"
	fi
else
	echo "-1"
fi
