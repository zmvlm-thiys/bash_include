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
test_assertLastCommandFailed() {
	false
	assertLastCommandFailed
}

test_assertLastCommandFailed_exits_with_failure_if_last_command_succeeded() {
	(
		true
		assertLastCommandFailed
		true
	)
	test $? != 0
}

test_assertLastCommandSucceed() {
	true
	assertLastCommandSucceed
}

test_assertLastCommandSucceed_exits_with_failure_if_last_command_failed() {
	(
		false
		assertLastCommandSucceed
		true
	)
	test $? != 0
}

teststage_proceed
test_assertEquals() {
	assertEquals "same" "same"
}

test_assertEquals_exits_with_failure_if_parameters_differ() {
	( assertEquals "but" "different"; )
	assertLastCommandFailed
}

teststage_proceed
test_assertOutput() {
	assertOutput 'same' echo 'same'
}

test_assertOutput_exits_with_failure_if_output_differs_from_parameter() {
	( assertEquals 'but' echo 'different'; )
	assertLastCommandFailed
}

test_assertOutput_passes_empty_parameters() {
	assertOutput $'\n|' printf '%s\n' '' '|'
}

test_assertErrorOutput() {
	assertErrorOutput 'same' echoError 'same'
}

test_assertErrorOutput_exits_with_failure_if_output_differs_from_parameter() {
	( assertErrorOutput 'but' echoError "different" )
	assertLastCommandFailed
}

test_assertErrorOutput_passes_empty_parameters() {
	assertErrorOutput $'\n|' printfError '%s\n' '' '|'
}

echoError() {
	1>&2 2>/dev/null echo "$@"
}

printfError() {
	1>&2 2>/dev/null printf "$@"
}

teststage_proceed
test_assertLastCommandFailed_failure_output() {
	true
	assertErrorOutput "assertion failed: last command unexpectly succeded" assertLastCommandFailed
}


test_testEnvironmentIndepdency1_set_value() {
	value=1;
}

test_testEnvironmentIndepdency2_assert_value_is_unset() {
	! test "${value+set}"
}

test_testIOIndepdency1_open_fd() {
	exec 3>/dev/null
}

test_testIOIndepdency2_write_to_fd_fails() {
	echo x 1>&3
	assertLastCommandFailed
}

testx_dontRunMe() {
	false
}

testcase_end "$@"
