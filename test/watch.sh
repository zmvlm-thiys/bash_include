#!/bin/bash

IFS=''
clear
while output=$(
	{
		exec 2>&1
		date
		time "$@"
	} |
	while read -rs line; do
		printf '%s\033%s[K\n' "$line"
	done
); do
	printf $'\033[H%s\n\033[J' "$output"
	sleep .5
done
