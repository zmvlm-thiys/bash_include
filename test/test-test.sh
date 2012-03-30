#!./tester
#
testcase_begin "$@"
test_runTest() {
	true
}

teststage_proceed
test_testFails() {
	_test_runTest false
	test $? != 0
}

teststage_proceed
test_testEnvironmentIndepdency_1_set_value() {
	value=1;
}

test_testEnvironmentIndepdency_2_assert_value_is_unset() {
	! test "${value+set}"
}

teststage_proceed
test_testIOIndepdency_1_open_fd() {
	exec 3>/dev/null
}

test_testIOIndepdency_2_write_to_fd_fails() {
	! echo x 1>&3
}

testx_dontRunMe() {
	false
}

testcase_end "$@"
