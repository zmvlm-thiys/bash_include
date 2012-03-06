include autotools/common.am
doc_DATA=

dist_doc_DATA=

pkgconfig_DATA=bash_include.pc
dist_DATA_IN+=bash_include.pc.in


dist_doc_DATA+=AUTHORS COPYING README

include etc/Makefile.am
include src/Makefile.am

install-data: install-data-am
# install: install-exec-recursive install-data-am
install: install-data-am
