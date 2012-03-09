#!/bin/bash
#

for testcase in include test testcase msg; do
	"./test-$testcase.sh"
	echo
done