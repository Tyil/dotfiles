#! /usr/bin/env sh

# .local/var
# .config
# EOF

while read -r line
do
	# Skip empty lines and shebang
	if [ "${line}" = "" ] || expr "${line}" : "^#!" > /dev/null
	then
		continue
	fi

	# End loop on EOF mark
	if [ "${line}" = "# EOF" ]
	then
		break
	fi

	# Remove comment marks
	path="${HOME}/$(echo "${line}" | sed 's/^#\s*//')"

	# Check if the path exists yet
	if [ -e "${path}" ]
	then
		continue
	fi

	echo "  > mkdir -p ${path}"
	#mkdir -p "${path}"
done < "$0"
