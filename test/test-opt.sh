#!./tester
#
SCRIPT_NAME="test-opt"
SCRIPT_PREFIX=""
SCRIPT_VERSION="1.0"
SCRIPT_DESCRIPTION="testcase for opt"
SCRIPT_PACKAGE="bash_include"
SCRIPT_API="1"

include opt
include assert

script_begin

teststage_setup() {
	option=
	opt_option_00=(b "b"  "boolean"           'option=boolean')
	opt_option_00[opt_HELP]="boolean."
	opt_option_01=(B "c"  "counter"           '(( ++counter ))')
	opt_option_01[opt_HELP]="counter."
	opt_option_02=(i "i"  "integer"         'option="integer=$parameter"')
	opt_option_02[opt_HELP]="integer."
	opt_option_03=(I "I"  "integer-default" 'option="integer=$parameter"' 10)
	opt_option_03[opt_HELP]="integer with default parameter."
	opt_option_04=(f "f"  "floating"         'option="floating=$parameter"')
	opt_option_04[opt_HELP]="floating."
	opt_option_05=(F "F"  "floating-default" 'option="floating=$parameter"' 1.0e+10)
	opt_option_05[opt_HELP]="floating with default parameter."
	opt_option_06=(s "s"  "string"         'option="string=$parameter"')
	opt_option_06[opt_HELP]="string."
	opt_option_07=(S "S"  "string-default" 'option="string=$parameter"' "default")
	opt_option_07[opt_HELP]="string with default parameter."
	opt_option_08=(s "e"  "string-empty" 'option="string=$parameter"' "")
	opt_option_08[opt_HELP]="string with empty default parameter."
	opt_option_09=(r "r"  "raw"         'option="raw=$parameter"')
	opt_option_09[opt_HELP]="raw."
	opt_option_10=(R "R"  "raw-default" 'option="raw=$parameter"' "default")
	opt_option_10[opt_HELP]="raw with default parameter."
}
testcase_begin "$@"

test_opt_show_version() {
	assert that opt_show_version writes 'bash_include test-opt-1.0'
}

test_opt_show_usage() {
	assert that opt_show_usage writes "\
bash_include test-opt-1.0
Usage: test-opt -bc -iINT -I[INT] -fFLOAT -F[FLOAT] -sSTRING -S[STRING] -e[STRING] -rSTRING -R[STRING]
Try 'test-opt --help' for more information."
}

test_opt_show_usage_shows_additional_usage() {
	opt_additional_usage="files"
	assert that opt_show_usage writes "\
bash_include test-opt-1.0
Usage: test-opt -bc -iINT -I[INT] -fFLOAT -F[FLOAT] -sSTRING -S[STRING] -e[STRING] -rSTRING -R[STRING] files
Try 'test-opt --help' for more information."
}

teststage_proceed
test_opt_show_help() {
	COLUMNS=80
	assert that opt_show_help writes "\
bash_include test-opt-1.0
Usage: test-opt -bc -iINT -I[INT] -fFLOAT -F[FLOAT] -sSTRING -S[STRING] -e[STRING] -rSTRING -R[STRING]
Try 'test-opt --help' for more information.

  -b, --boolean                  boolean.
  -c, --counter                  counter.
  -i, --integer=INT              integer.
  -I, --integer-default[=INT]    integer with default parameter.
  -f, --floating=FLOAT           floating.
  -F, --floating-default[=FLOAT] floating with default parameter.
  -s, --string=STRING            string.
  -S, --string-default[=STRING]  string with default parameter.
  -e, --string-empty[=STRING]    string with empty default parameter.
  -r, --raw=STRING               raw.
  -R, --raw-default[=STRING]     raw with default parameter."
}

test_opt_show_help_shows_additional_entry() {
	COLUMNS=80
	opt_additional_help_entry_00=( "additional" "help entry")
	assert that opt_show_help writes "\
bash_include test-opt-1.0
Usage: test-opt -bc -iINT -I[INT] -fFLOAT -F[FLOAT] -sSTRING -S[STRING] -e[STRING] -rSTRING -R[STRING]
Try 'test-opt --help' for more information.

  -b, --boolean                  boolean.
  -c, --counter                  counter.
  -i, --integer=INT              integer.
  -I, --integer-default[=INT]    integer with default parameter.
  -f, --floating=FLOAT           floating.
  -F, --floating-default[=FLOAT] floating with default parameter.
  -s, --string=STRING            string.
  -S, --string-default[=STRING]  string with default parameter.
  -e, --string-empty[=STRING]    string with empty default parameter.
  -r, --raw=STRING               raw.
  -R, --raw-default[=STRING]     raw with default parameter.
additional                       help entry"
}

teststage_proceed
option=
counter=0

test_opt_get_longopt_with_parameter() {
	opt_get --integer=10
	assert that $? equals 0
	assert that option contains integer=10
	assert that opt_no_options[@] contains ""
}

test_opt_get_longopt_without_parameter() {
	opt_get --boolean
	assert that $? equals 0
	assert that option contains boolean
	assert that opt_no_options[@] contains ""
}

test_opt_get_shortopt_without_parameter() {
	opt_get -b
	assert that $? equals 0
	assert that option contains boolean
	assert that opt_no_options[@] contains ""
}

test_opt_get_shortopt_with_attached_parameter() {
	opt_get -svalue
	assert that option contains string=value
	assert that opt_no_options[@] contains ""
}

test_opt_get_shortopt_with_seperate_parameter() {
	opt_get -s value
	assert that $? equals 0
	assert that option contains string=value
	assert that opt_no_options[@] contains ""
}

teststage_proceed
test_opt_get_longopt_without_required_parameter_returns_err_INVAL() {
	opt_get --integer
	assert that $? equals $err_INVAL
	assert that option contains ""
	assert that opt_no_options[@] contains ""
}

test_opt_get_shortopt_without_required_parameter_returns_err_INVAL() {
	opt_get -i
	assert that $? equals $err_INVAL
	assert that option contains ""
	assert that opt_no_options[@] contains ""
}

teststage_proceed
test_opt_get_consecutive_shortopts_without_parameter() {
	opt_get -bcc
	assert that $? equals 0
	assert that option contains boolean
	assert that counter contains 2
	assert that opt_no_options[@] contains ""
}

test_opt_get_consecutive_shortopts_with_attached_parameter() {
	opt_get -ccsvalue
	assert that $? equals 0
	assert that option contains "string=value"
	assert that counter contains 2
	assert that opt_no_options[@] contains ""
}

test_opt_get_consecutive_shortopts_with_seperate_parameter() {
	opt_get -ccs value
	assert that $? equals 0
	assert that option contains "string=value"
	assert that counter contains 2
	assert that opt_no_options[@] contains ""
}

test_opt_get_consecutive_shortopts_without_optional_parameter() {
	opt_get -ccS
	assert that $? equals 0
	assert that option contains "string=default"
	assert that counter contains 2
	assert that opt_no_options[@] contains ""
}

test_opt_get_consecutive_shortopts_with_attached_optional_parameter() {
	opt_get -ccSvalue
	assert that $? equals 0
	assert that option contains "string=value"
	assert that counter contains 2
	assert that opt_no_options[@] contains ""
}

test_opt_get_consecutive_shortopts_with_seperate_optional_parameter() {
	opt_get -ccS value
	assert that $? equals 0
	assert that option contains "string=value"
	assert that counter contains 2
	assert that opt_no_options[@] contains ""
}

test_opt_get_longopts_without_optional_parameter() {
	opt_get --string-default
	assert that $? equals 0
	assert that option contains "string=default"
	assert that opt_no_options[@] contains ""
}

teststage_proceed
test_opt_get_no_option_argument() {
	opt_get argument
	assert that $? equals 0
	assert that option contains ""
	assert that opt_no_options[@] contains "argument"
}

test_opt_get_options_and_no_option_arguments() {
	opt_get -ccS value -c first_argument -- -not_an_option
	assert that $? equals 0
	assert that option contains "string=value"
	assert that counter contains 3
	assert that opt_no_options[@] contains "first_argument -not_an_option"
}

teststage_proceed
teststage_setup() {
	:
}

xtest_opt_option_creates_options() {
	opt_option "${opt_fields[@]}"
	opt_option "${opt_fields[@]}"
	options=( "${!opt_option_@}" )
	options_count="${#options[@]}"
	assert that options_count contains 2
}

xtest_opt_option_initializes_option() {
	opt_option "${opt_fields[@]}"
	options=( "${!opt_option_@}" )
	for field in "${opt_fields[@]}"; do 
		assert that "${options[0]}[opt_$field]" contains $field
	done
}

xtest_opt_option_uses_named_parameters() {
	opt_option help=HELP action=ACTION default=DEFAULT short=SHORT long=LONG type=TYPE
	options=( "${!opt_option_@}" )
	for field in "${opt_fields[@]}"; do 
		assert that "${options[0]}[opt_$field]" contains $field
	done
}

test_opt_option_example(){
	opt_option b "b" "boolean" action='option=boolean' help="boolean."
	opt_option B "c" "counter" action='(( ++counter ))' help="counter."
	opt_option i "i" "integer" action='option="integer=$parameter"' help="integer."
	opt_option I "I" "integer-default" default=10 action='option="integer=$parameter"' help="integer with default parameter."
	opt_option f "f" "floating" action='option="floating=$parameter"' help="floating."
	opt_option F "F" "floating-default" default=1.0e+10 action='option="floating=$parameter"' help="floating with default parameter."
	opt_option s "s" "string" action'option="string=$parameter"' help="string."
	opt_option S "S" "string-default" default='default' 'option="string=$parameter"' help="string with default parameter."
	opt_option s "e" "string-empty" default= action='option="string=$parameter"' help="string with empty default parameter."
	opt_option r "r" "raw" action='option="raw=$parameter"' help="raw."
	opt_option R "R" "raw-default" default="default" action='option="raw=$parameter"' help="raw with default parameter."
	COLUMNS=80
	assert that opt_show_help writes "\
bash_include test-opt-1.0
Usage: test-opt -bc -iINT -I[INT] -fFLOAT -F[FLOAT] -sSTRING -S[STRING] -e[STRING] -rSTRING -R[STRING]
Try 'test-opt --help' for more information.

  -b, --boolean                  boolean.
  -c, --counter                  counter.
  -i, --integer=INT              integer.
  -I, --integer-default[=INT]    integer with default parameter.
  -f, --floating=FLOAT           floating.
  -F, --floating-default[=FLOAT] floating with default parameter.
  -s, --string=STRING            string.
  -S, --string-default[=STRING]  string with default parameter.
  -e, --string-empty[=STRING]    string with empty default parameter.
  -r, --raw=STRING               raw.
  -R, --raw-default[=STRING]     raw with default parameter."
}
testcase_end "$@"
