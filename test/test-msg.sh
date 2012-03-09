#!./tester
#
include msg

testcase_begin "$@"
program_name=program

test_msg_message() {
	assertOutput "program: message" msg_message "message"
}

test_msg_message_is_silent_if_verbose_level_is_zero() {
	local msg_verbose_level=0
	assertOutput "" msg_message "message"
}

test_msg_message_verbose_message() {
	local msg_verbose_level=2
	assertOutput "program: verbose message" msg_message "" "verbose message"
}

test_msg_message_is_silent_if_first_parameter_is_empty() {
	assertOutput "" msg_message "" "verbose message"
}

test_DEBUG() {
	msg_debug_level=1
	assertErrorOutput "debug message" DEBUG "debug message"
}

test_DEBUG_is_silent_if_verbose_level_is_zero() {
	local msg_debug_level=0
	assertErrorOutput "" DEBUG "message"
}

test_DEBUG_debug_message() {
	local msg_debug_level=2
	assertErrorOutput "verbose debug message" DEBUG "" "verbose debug message"
}

test_DEBUG_is_silent_if_first_parameter_is_empty() {
	assertErrorOutput "" DEBUG "" "verbose debug message"
}

test_msg_error() {
	assertErrorOutput "program: error message" msg_error "error message"
}

test_msg_error_returns_msg_error_code() {
	local msg_error_code=123
	msg_error "error message" 2>&-
	assertEquals $msg_error_code $?
}

test_msg_error_exits_if_msg_panic_is_true() {
	local msg_panic=true
	(
		msg_error "error message" 2>&-
		true
	)
	assertLastCommandFailed
}

test_msg_error_returns_if_msg_panic_is_false() {
	(
		msg_error "error message" 2>&-
		true
	)
	assertLastCommandSucceed
}

test_msg_error_returns_2nd_parameter_if_provided() {
	msg_error "error message" 123 2>&-
	assertEquals 123 $?
}

testcase_end "$@"
