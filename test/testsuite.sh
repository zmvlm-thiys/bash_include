#!/bin/bash
#

for testcase in include test assert testcase err var msg opt path; do
	"./test-$testcase.sh"
	echo
done