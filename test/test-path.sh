#!./tester
#
include path
include assert

testcase_begin "$@"
test_remove_trailing_slash() {
	assert that path_remove_trailing_slash "/test me/" writes "/test me"
	assert that path_remove_trailing_slash "/test me" writes "/test me"
	assert that path_remove_trailing_slash "/test" "me" writes "/test"
	assert that path_remove_trailing_slash "/test//me////" writes "/test//me"
	assert that path_remove_trailing_slash "" writes "."
	assert that path_remove_trailing_slash "/" writes "/"
}

test_remove_trailing_slash_reading_from_pipe() {
	echo "/test me/" | assert that path_remove_trailing_slash writes "/test me"
	echo "/test me" | assert that path_remove_trailing_slash writes "/test me"
	echo "/test//me////" | assert that path_remove_trailing_slash writes "/test//me"
	echo "/test/you" | assert that path_remove_trailing_slash "/test//me" writes "/test//me"
}

test_simplify() {
	assert that path_simplify "/test me/" writes "/test me"
	assert that path_simplify "/test/you/../me" writes "/test/me"
	assert that path_simplify "/test/.///./me" writes "/test/me"
	assert that path_simplify "test me/" writes "test me"
	assert that path_simplify "test/you/../me" writes "test/me"
	assert that path_simplify "test/././me" writes "test/me"
	assert that path_simplify "" writes "."
	assert that path_simplify "." writes "."
	assert that path_simplify ".." writes ".."
	assert that path_simplify "./x/../.." writes ".."
	assert that path_simplify "a/x/../.." writes "."
	assert that path_simplify "a/./x/../.././../../a/b/../../c" writes "../../c"
	assert that path_simplify "/" writes "/"
	assert that path_simplify "/." writes "/"
	assert that path_simplify "/.." writes "/"
	assert that path_simplify "///" writes "/"
	assert that path_simplify "/./x/../.." writes "/"
	assert that path_simplify "/a/.." writes "/"
	assert that path_simplify "/a/../c" writes "/c"
	assert that path_simplify "/a/./../../a/b/../../d" writes "/d"
}

testcase_end "$@"
