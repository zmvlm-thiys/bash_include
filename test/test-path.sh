#!./tester
#
include path
include assert

monkey_input="/- /- -/ -/./a/..// "$'\r\n\t'"/@\\/\${}/;'"
simplified_monkey_input="/- /- -/ -/ "$'\r\n\t'"/@\\/\${}/;'"
testcase_begin "$@"
test_remove_trailing_slash() {
	assert that path_remove_trailing_slash "/test/me/" writes "/test/me"
}
test_remove_trailing_slash_does_nothing_if_path_has_no_trailing_slash() {
	assert that path_remove_trailing_slash "/test me" writes "/test me"
}
test_remove_trailing_slash_removes_multiple_trailing_slashes() {
	assert that path_remove_trailing_slash "/test/me////" writes "/test/me"
}
test_remove_trailing_slash_does_nothing_for_empty_path() {
	assert that path_remove_trailing_slash "" writes ""
}
test_remove_trailing_slash_does_nothing_for_root() {
	assert that path_remove_trailing_slash "/" writes "/"
}
test_remove_trailing_slash_ignores_second_parameter() {
	assert that path_remove_trailing_slash "/test" "me" writes "/test"
}
test_remove_trailing_slash_ignores_multiple_non_trailing_slashes() {
	assert that path_remove_trailing_slash "///test///me" writes "///test///me"
}
test_remove_trailing_slash_monkey_input() {
	assert that path_remove_trailing_slash "$monkey_input/" writes "$monkey_input"
}
test_remove_trailing_slash_reads_from_stdin() {
	echo "/test/me/" | assert that path_remove_trailing_slash writes "/test/me"
}

teststage_proceed
test_is_absolute_returns_true_for_slash() {
	assert that path_is_absolute '/' returns 0
}
test_is_absolute_returns_true_for_absolute_path() {
	assert that path_is_absolute '/test/me' returns 0
}
test_is_absolute_returns_false_for_empty_path() {
	assert that path_is_absolute '' returns 1
}
test_is_absolute_returns_false_for_dot() {
	assert that path_is_absolute '.' returns 1
}
test_is_absolute_returns_false_for_relative_path() {
	assert that path_is_absolute 'test/me' returns 1
}
test_is_absolute_monkey_input() {
	assert that path_is_absolute "$monkey_input" returns 0
}
test_is_absolute_reads_from_stdin() {
	echo 'test/me' | assert that path_is_absolute returns 1
	echo '/test/me' | assert that path_is_absolute returns 0
}
test_is_relative_returns_true_for_empty_path() {
	assert that path_is_relative '' returns 0
}
test_is_relative_returns_true_for_dot() {
	assert that path_is_relative '.' returns 0
}
test_is_relative_returns_true_for_relative_path() {
	assert that path_is_relative 'test/me' returns 0
}
test_is_relative_returns_false_for_slash() {
	assert that path_is_relative '/' returns 1
}
test_is_relative_returns_false_for_absolute_path() {
	assert that path_is_relative '/test/me' returns 1
}
test_is_relative_monkey_input() {
	assert that path_is_relative "$monkey_input" returns 1
}
test_is_relative_reads_from_stdin() {
	echo 'test/me' | assert that path_is_relative returns 0
	echo '/test/me' | assert that path_is_relative returns 1
}

teststage_proceed
test_simplify_writes_dot_if_path_is_empty() {
	assert that path_simplify "" writes "."
}
test_simplify_keeps_dot() {
	assert that path_simplify "." writes "."
}
test_simplify_keeps_dot_dot() {
	assert that path_simplify ".." writes ".."
}
test_simplify_keeps_leading_dot_dot() {
	assert that path_simplify "../" writes ".."
	assert that path_simplify "../a" writes "../a"
}
test_simplify_keeps_single_slash() {
	assert that path_simplify "/" writes "/"
}
test_simplify_removes_trailing_slash_dot() {
	assert that path_simplify "test/me/." writes "test/me"
}
test_simplify_collapses_inner_slash_dot_slash() {
	assert that path_simplify "test/./me" writes "test/me"
}
test_simplify_removes_leading_dot_slash() {
	assert that path_simplify "./test/me" writes "test/me"
}
test_simplify_removes_trailing_slashs() {
	assert that path_simplify "/test/me/" writes "/test/me"
}
test_simplify_removes_dot_after_leading_slash() {
	assert that path_simplify "/." writes "/"
}
test_simplify_removes_dot_slash_after_leading_slash() {
	assert that path_simplify "/./a" writes "/a"
}
test_simplify_removes_dot_dot_after_leading_slash() {
	assert that path_simplify "/.." writes "/"
}
test_simplify_removes_dot_dot_slash_after_leading_slash() {
	assert that path_simplify "/../a" writes "/a"
}
test_simplify_merges_consecutive_slashs() {
	assert that path_simplify "/test///me" writes "/test/me"
	assert that path_simplify "///test/me" writes "/test/me"
	assert that path_simplify "///" writes "/"
}
test_simplify_removes_dotdot_and_preceeding_path_element() {
	assert that path_simplify "test/you/../me" writes "test/me"
}
test_simplify_removes_consecutive_slash_dot_dot_and_as_many_preceeding_path_elements() {
	assert that path_simplify "test/you/and/../../me" writes "test/me"
}
test_simplify_removes_consecutive_slash_dot() {
	assert that path_simplify "test/././me" writes "test/me"
}
test_simplify_writes_dot_if_path_returns_to_origin() {
	assert that path_simplify "a/x/../.." writes "."
	assert that path_simplify "a/x/../../b/.." writes "."
}
test_simplify_prepends_dot_dot_slash_if_path_leaves_origin() {
	assert that path_simplify "x/../.." writes ".."
	assert that path_simplify "x/../../b/../../c" writes "../../c"
}
test_simplify_does_not_prepend_dot_dot_slash_if_path_is_at_root() {
	assert that path_simplify "/test/../.." writes "/"
}
test_simplify_writes_slash_if_path_returns_to_root() {
	assert that path_simplify "/test/.." writes "/"
}
test_simplify_monkey_input() {
	assert that path_simplify "$monkey_input/" writes "$simplified_monkey_input"
}
test_simplify_reads_from_stdin() {
	echo "/test/./me/" | assert that path_simplify writes "/test/me"
}

teststage_proceed
test_make_absolute_writes_first_parameter_slash_second_parameter_if_first_parameter_is_an_absolute_path_an_second_parameter_is_a_relative_path() {
	assert that path_make_absolute "/test" "me" writes "/test/me"
}
test_make_absolute_writes_second_parameter_if_second_parameter_is_an_absolute_path() {
	assert that path_make_absolute "/other" "/test/me" writes "/test/me"
}
test_make_absolute_writes_PWD_slash_first_parameter_slash_second_parameter_if_both_parameters_are_relative_paths() {
	assert that path_make_absolute "test" "me" writes "$PWD/test/me"
}
test_make_absolute_monkey_input() {
	assert that path_make_absolute "$monkey_input" writes "$monkey_input"
}
test_make_absolute_reads_from_stdin() {
	echo "test/me" | assert that path_make_absolute writes "$PWD/test/me"
}

teststage_proceed
test_make_relative_dot_writes_dot() {
	assert that path_make_relative '.' writes '.'
}
test_make_relative_writes_dot_dot_if_second_parameter_is_parent_path_of_first_parameter() {
	assert that path_make_relative '/test/me' '/test' writes '..'
}
test_make_relative_dot_dot_slash_dot_dot_writes_dot_dot_slash_dot_dot() {
	assert that path_make_relative '../..' writes '../..'
}
test_make_relative_writes_child_name_if_second_parameter_is_child_path_of_first_parameter() {
	assert that path_make_relative '/test' '/test/me' writes 'me'
}
test_make_relative_writes_dot_if_both_parameters_are_identical() {
	assert that path_make_relative '/test/me' '/test/me' writes '.'
}
test_make_relative_monkey_input() {
	assert that path_make_relative "$monkey_input" "$monkey_input" writes "."
}
testcase_end "$@"
