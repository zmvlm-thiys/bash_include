AC_DEFUN([AX_TRANSFORM],
[
AC_BEFORE([AC_OUTPUT], [$0])dnl
AC_PATH_PROG([ax__make],[make],[/usr/bin/make])
printf '#!%s -sRBf\n' "${ax__make}" > config.transform
ax__apostroph="'\\''"
ax__subst_vars="`printf '%s\n' ${ac_subst_vars} {,abs_}{,top_}{src,build}dir top_build_prefix INSTALL MKDIR_P | LC_ALL=C sort -u`"
for x in ${ax__subst_vars}; do
	v="${!x}";
	v="${v//\\/\\\\}";
	v="${v// /\\ }";
	v="${v//&/\\&}";
	v="${v//
/\n}";
	v="${v//"'"/${ax__apostroph}}";
	v="${v//|/\\|}";
	v="${v//#/\\#}";
	printf "%s=%s"'\n' "$x" "${v}";
done >> config.transform
cat >> config.transform <<_ACEOF

ax__transform=sed '\\
_ACEOF
for x in ${ax__subst_vars}; do
	printf '\ts|@%s@|$(%s)|g;\\\n' "${x}" "${x}"
done >> config.transform
cat >> config.transform <<_ACEOF
'
.SUFFIXES:
% : %.in
	@printf '%s\n' 'config.transform: creating \$(@)'
	@${MKDIR_P} '\$(@D)'
	@\$(ax__transform) '\$(<)' > '\$(@)'
_ACEOF
chmod 755 config.transform
])

AC_CONFIG_COMMANDS_POST([AX_TRANSFORM])
