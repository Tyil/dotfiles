#!/usr/bin/env sh

if [ -d "${HOME}/.spacemacs.d" ] || [ -d "${HOME}/.emacs.d" ]
then
	exit 0
fi

echo "Cloning spacemacs"
git clone "https://github.com/syl20bnr/spacemacs" "${HOME}/.emacs.d"

