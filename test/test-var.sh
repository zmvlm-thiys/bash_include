#!./tester
#
include var
include assert

testcase_begin "$@"
unset undefined
defined='content'
empty=
test_var_is_set_succeeds_if_variable_is_defined() {
	assert that var_is_set defined returns 0
}
test_var_is_set_fails_if_variable_is_undefined() {
	assert that var_is_set undefined returns 1
}

test_var_not_set_fails_if_variable_is_defined() {
	assert that var_not_set defined returns 1
}
test_var_not_set_succeeds_if_variable_is_undefined() {
	assert that var_not_set undefined returns 0
}

test_var_is_empty_succeeds_if_variable_is_empty() {
	assert that var_is_empty empty returns 0
}
test_var_is_empty_succeeds_if_variable_is_undefined() {
	assert that var_is_empty undefined returns 0
}
test_var_is_empty_fails_if_variable_is_not_empty() {
	assert that var_is_empty defined returns 1
}

test_var_not_empty_fails_if_variable_is_empty() {
	assert that var_not_empty empty returns 1
}
test_var_not_empty_fails_if_variable_is_undefined() {
	assert that var_not_empty undefined returns 1
}
test_var_not_empty_succeeds_if_variable_is_not_empty() {
	assert that var_not_empty defined returns 0
}

teststage_proceed
test_var_escape() {
	assert that var_escape '"$\' writes '"\"\$\\"'
}

teststage_proceed
test_var_print() {
	assert that var_print defined writes 'defined="content"'
}
test_var_print_prints_nothing_for_undefined_variable() {
	assert that var_print undefined writes ''
}
test_var_print_monkeytest() {
	assert that var_print 'defined|q 09)|834-3+' writes ''
}
test_var_print_escapes_correctly() {
	needs_escaping='"$
\'
	assert that var_print needs_escaping writes 'needs_escaping="\"\$
\\"'
}

teststage_proceed
test_var_expand() {
	assert that var_expand defined writes content
}

test_var_expand_array_variable() {
	array=( some text )
	assert that var_expand array[*] writes "some text"
}

test_var_expand_multiple_arguments() {
	other=more
	assert that var_expand other defined writes "more content"
}

test_var_expand_advanced_expansion() {
	assert that var_expand "defined/c/k" writes "kontent"
}

test_var_expand_indirect_expansion() {
	pointer=defined
	assert that var_expand !pointer writes "content"
}

teststage_proceed
test_@() {
	assert that @ defined writes "content"
}

teststage_proceed
test_var() {
	var var=value
	assert that var contains value
}
test_var_set_if_undefined_sets_value() {
	var @{var-value}
	assert that var contains "value"
}
test_var_set_if_undefined_keeps_value() {
	var @{defined-"bad content"}
	assert that defined contains "content"
}

teststage_proceed
test_var_sets_an_array_element() {
	var var[10]=10
	assert that var[0] contains ''
	assert that var[10] contains 10
}

test_var_resets_an_undefined_array_element() {
	var @{var[10]-10}
	assert that var[0] contains ''
	assert that var[10] contains 10
}

test_var_not_resets_an_defined_array_element() {
	var[10]=10
	var @{var[10]-0}
	assert that var[0] contains ''
	assert that var[10] contains 10
}

test_var_fails_for_invalid_varname() {
	assert that var @=0 returns $err_INVAL
}

test_var_reset_fails_with_empty_varname() {
	assert that var @{-fails} returns $err_INVAL
}

test_var_multiple_arguments(){
	var var[0]=10 @{var[10]-10} @{var[10]-0} var[0]=0
	assert that var[@] contains "0 10"
}

teststage_proceed
test_var_init() {
	var_init undefined "content"
	assert that undefined contains content
}
test_var_init_does_not_resets_predefined() {
	var_init defined "bad content"
	assert that defined contains content
}
test_var_init_resets_empty() {
	empty=
	var_init empty "content"
	assert that empty contains content
}
test_var_init_does_not_resets_empty_if_3rd_parameter_is_set() {
	empty=
	var_init empty "content" ''
	assert that empty contains ''
}

teststage_proceed
test_var_script_init_prefixes_variable_name() {
	SCRIPT_PREFIX=script
	var_script_init var content
	assert that var contains ''
	assert that script_var contains content
}

testcase_end "$@"
