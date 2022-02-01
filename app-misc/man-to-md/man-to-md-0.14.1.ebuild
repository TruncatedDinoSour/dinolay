# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Converts man pages to Markdown "
HOMEPAGE="https://github.com/mle86/man-to-md"
SRC_URI="https://github.com/mle86/man-to-md/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=dev-lang/perl-5.34.0-r6
man? ( >=sys-apps/man-db-2.9.4-r1 )
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="+man"

src_test() {
    true
}

src_configure() {
    sed -i '1s/.*/#!\/usr\/bin\/env perl/' man-to-md.pl
    sed -i 's/man-to-md.pl/man-to-md/g' doc/man-to-md.1
    mv man-to-md.pl man-to-md
}

src_install() {
    dobin man-to-md
    use man && doman doc/man-to-md.1
}

