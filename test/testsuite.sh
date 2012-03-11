#!/bin/bash
#

for testcase in include test assert testcase err var msg; do
	"./test-$testcase.sh"
	echo
done