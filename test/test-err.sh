#!./tester
#
include err
include assert

testcase_begin "$@"
test_err_str() {
	assertOutput "No error" err_str 0
	assertOutput "Operation not permitted" err_str 1
}
test_err_str_returns_err_INVAL_if_unknown_error_code_is_passed() {
	err_str 256
	assertEquals "$err_INVAL" $?
}
test_err_str_returns_err_INVAL_if_negative_error_code_is_passed() {
	err_str -1
	assertEquals "$err_INVAL" $?
}
test_err_str_returns_err_INVAL_if_non_integral_is_passed() {
	err_str a
	assertEquals "$err_INVAL" $?
}
testcase_end "$@"
