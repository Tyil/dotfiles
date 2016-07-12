#!/usr/bin/env sh

if [ -d "${HOME}/.vim/bundle/Vundle.vim" ]
then
	exit 0
fi

echo "Cloning Vundle.vim"
git \
	clone \
	"https://github.com/VundleVim/Vundle.vim.git" \
	"${HOME}/.vim/bundle/Vundle.vim"

