#! /usr/bin/env sh

if [ ! -e "${HOME}/.config/tmux/inet-device" ]
then
	echo "  > Setting tmux inet device to eth0"
	echo "eth0" >> "${HOME}/.config/tmux/inet-device"
fi
