#!./tester
#
include assert

testcase_begin "$@"
test_assert() {
	assert true
}

teststage_proceed
test_assert_exits_with_failure_for_false() {
	! (
		assert false
		true
	)
}

teststage_proceed
test_assert_defines_that() {
	assert that
}

test_assert_defines_that_local() {
	assert true
	that
	assert test 0 != $?
}

teststage_proceed
test_assert_that_equals() {
	assert that 'same' equals 'same'
}

test_assert_that_equals_exits_with_failure_for_unexpected_value() {
	! (
		assert that 'but' equals 'different'
		true
	)
}

test_assert_that_contains() {
	x=same
	assert that x contains 'same'
}

test_assert_that_contains_exits_with_failure_for_unexpected_value() {
	! (
		x=but
		assert that x contains 'different'
		true
	)
}
teststage_proceed
test_assert_that_writes() {
	assert that echo output writes output
}

test_assert_that_writes_exits_with_failure_for_unexpected_output() {
	! (
		assert that echo output writes nothing
		true
	)
}

teststage_proceed
test_assert_that_returns() {
	assert that true returns 0
}

test_assert_that_returns_exits_with_failure_for_unexpected_return_codes() {
	! (
		assert that true returns 1
		true
	)
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
	!( assertEquals "but" "different"; )
}

teststage_proceed
test_assertOutput() {
	assertOutput 'same' echo 'same'
}

test_assertOutput_exits_with_failure_if_output_differs_from_parameter() {
	!( assertEquals 'but' echo 'different'; )
}

test_assertOutput_passes_empty_parameters() {
	assertOutput $'\n|' printf '%s\n' '' '|'
}

test_assertErrorOutput() {
	assertErrorOutput 'same' echoError 'same'
}

test_assertErrorOutput_exits_with_failure_if_output_differs_from_parameter() {
	! ( assertErrorOutput 'but' echoError "different" )
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

testcase_end "$@"
