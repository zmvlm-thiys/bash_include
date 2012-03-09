# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit flag-o-matic

DESCRIPTION="Bash enhancement for repeative complex scripts"
HOMEPAGE="http://struction.de/bash_include"
SRC_URI="http://struction.de/bash_include/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="app-shells/bash
       "
#bash library

MAKEOPTS="${MAKEOPTS} -j1"

src_compile() {
	econf || die "econf failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}
