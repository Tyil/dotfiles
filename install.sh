#! /usr/bin/env sh

readonly DOTDIR="${HOME}/dotfiles"

expand() {
	string=$(echo "$1" | sed 's|^~/|${HOME}/|')
	delimiter="__apply_shell_expansion_delimiter__"
	command="cat <<$delimiter"$'\n'"$string"$'\n'"$delimiter"

	eval "$command"
}

get_dotdir()
{
	cwd=$(pwd)

	if [ ! -d "${DOTDIR}" ]
	then
		git clone https://github.com/tyil/dotfiles.git "${DOTDIR}" 2>&1 > /dev/null

		return
	fi

	cd "${DOTDIR}"
	git pull 2>&1 > /dev/null
	cd "${cwd}"
}

install_file()
{
	file_base="$(expand ${DOTDIR}/$1)"
	file_target="$(expand $2)"
	file_target_dir=$(dirname "${file_target}")

	# Ensure the base exists
	if [ ! -f "${file_base}" ]
	then
		echo "${file_base} does not exist" >&2
		return 2
	fi

	# Ensure the directory exists
	if [ ! -d "${file_target_dir}" ]
	then
		echo "> ${file_target_dir}"
		mkdir -p "${file_target_dir}"
	fi

	# If the target does not exist or is outdated, copy over the base
	if [ ! -e "${file_target}" ] || base_newer "${file_base}" "${file_target}"
	then
		echo "> ${file_target}"
		cp "${file_base}" "${file_target}"

		return 0
	fi

	# Complain
	echo "= ${file_target}"
	return 1
}

install_dir()
{
	dir_base="${DOTDIR}/$1"
	dir_cwd=$(pwd)
	dir_target="$(expand $2)"
	dir_target_dir=$(dirname "$2")

	# Ensure the base exists
	if [ ! -d "${dir_base}" ]
	then
		echo "${dir_base} does not exist" >&2
		return 2
	fi

	cd "${dir_base}"
	find . -type f -print0 | while IFS= read -r -d $'\0' dir_i; do
		dir_file="$(echo "${dir_i}" | sed 's|^./||')"
		install_file "$1/${dir_file}" "${dir_target}/${dir_file}"
	done

	cd "${dir_cwd}"
}

base_newer()
{
	base_mod=$(perl -IFile::Stat -e 'print((stat("'$1'"))[9])')
	target_mod=$(perl -IFile::Stat -e 'print((stat("'$2'"))[9])')

	if [ "${target_mod}" -lt "${base_mod}" ]
	then
		return 0
	fi

	return 1
}

main()
{
	# Ensure the dotdir is available and up to date
	get_dotdir "${DOTDIR}"

	if [ ! -d "${DOTDIR}" ]
	then
		echo "Missing DOTDIR!" >&2
		exit 1
	fi

	# Install all single file configs
	while read line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		install_file $line
	done < "${DOTDIR}/.files"

	# Install all directories
	[ -e "${DOTDIR}/.dirs" ] && \
	while read line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		install_dir $line
	done < "${DOTDIR}/.dirs"

	# Run additional scripts
	[ -e "${DOTDIR}/.scripts" ] && \
	while read line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		script="${DOTDIR}/$(expand "${line}")"

		echo "x $script"
		$script > /dev/null
	done < "${DOTDIR}/.scripts"

	exit 0
}

main "$@"

