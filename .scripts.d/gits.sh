#! /usr/bin/env sh

readonly BASEDIR=$(dirname "$(readlink -f "$0")")
readonly REPOFILE="${BASEDIR}/files/git-repos"

main()
{
	if [ ! -e "${REPOFILE}" ]
	then
		return 1
	fi

	while read -r line
	do
		if [ "$line" = "" ]
		then
			continue
		fi

		update_git $line
	done < "${REPOFILE}"
	
}

expand() {
	string=$(echo "$1" | sed 's|^~/|${HOME}/|')
	delimiter="__apply_shell_expansion_delimiter__"
	command="cat << $(printf "%s\n%s\n%s" "$delimiter" "$string" "$delimiter")"

	eval "$command"
}

update_git()
{
	repo=$(expand "$1")
	destination=$(expand "$2")
	destdir=$(dirname "${destination}")

	if [ ! -d "${destdir}" ]
	then
		mkdir -p "${destdir}"
	fi

	if [ ! -d "${destination}" ]
	then
		git clone "${repo}" "${destination}"
		exit
	fi

	cwd=$(pwd)
	cd "${destination}"
	git pull
	cd "${cwd}"
}

main "$@"

