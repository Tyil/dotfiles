#!/usr/bin/env sh

main()
{
	branch="master"

	if test -n "$1"
	then
		branch="$1"
		shift
	fi

	for remote in $(git remote)
	do
		echo "Pushing to ${remote}:${branch}..."
		git push "${remote}" "${branch}" "$@"
	done
}

main "$@"

