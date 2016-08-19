#!/usr/bin/env sh

if [ ! -f "${HOME}/.config/tmux/inet-device" ]
then
	echo "eth0" > "${HOME}/.config/tmux/inet-device"
fi

