#!/usr/bin/env sh

if [ ! -f "${HOME}/.config/tmux/inet-device" ]
then
	echo "eth0" > "${HOME}/.config/tmux/inet-device"
fi

chmod +x "${HOME}/.config/tmux/status-right.pl"

