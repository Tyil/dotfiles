#! /usr/bin/env sh

BASEDIR=$(CDPATH="" cd -- "$(dirname -- "$0")" && pwd -P)

expand() {
	# shellcheck disable=SC2016
	string=$(echo "$1" | sed 's|^~/|${HOME}/|')
	delimiter="__apply_shell_expansion_delimiter__"
	command="cat << $(printf "%s\n%s\n%s" "$delimiter" "$string" "$delimiter")"

	eval "$command"
}

install_file()
{
	file_base="$(expand "${BASEDIR}/$1")"
	file_target="$(expand "$2")"
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

	# If the target does not exist, symlink it
	if [ ! -e "${file_target}" ]
	then
		echo "> ${file_target}"
		ln -s "${file_base}" "${file_target}"

		return 0
	fi

	# Complain
	echo "= ${file_target}"
	return 1
}

install_dir()
{
	dir_base="${BASEDIR}/$1"
	dir_cwd=$(pwd)

	# Ensure the base exists
	if [ ! -d "${dir_base}" ]
	then
		echo "${dir_base} does not exist" >&2
		return 2
	fi

	# shellcheck disable=SC2164
	cd "${dir_base}"

	for dir_i in *
	do
		if [ -d "${dir_i}" ]
		then
			install_dir "$1/${dir_i}" "$2/${dir_i}"
			continue
		fi

		dir_file="$(echo "${dir_i}" | sed 's|^\./||')"
		install_file "$1/${dir_file}" "$(expand "$2")/${dir_file}"
	done

	# shellcheck disable=SC2164
	cd "${dir_cwd}"
}

main()
{
	# Install all single file configs
	while read -r line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		source=$(echo "$line" | awk '{ print $1 }')
		dest=$(echo "$line" | awk '{ print $2 }')

		install_file "${source}" "${dest}"
	done < "${BASEDIR}/.files"

	# Install all directories
	[ -e "${BASEDIR}/.dirs" ] && \
	while read -r line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		source=$(echo "$line" | awk '{ print $1 }')
		dest=$(echo "$line" | awk '{ print $2 }')

		install_dir "${source}" "${dest}"
	done < "${BASEDIR}/.dirs"

	# Run additional scripts
	[ -e "${BASEDIR}/.scripts" ] && \
	while read -r line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		script="${BASEDIR}/$(expand "${line}")"

		echo "x $script"
		$script
	done < "${BASEDIR}/.scripts"

	exit 0
}

main "$@"
