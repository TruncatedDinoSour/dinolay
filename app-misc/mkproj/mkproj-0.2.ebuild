# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{3..10} )

DESCRIPTION="Make and use templates for projects"
HOMEPAGE="https://ari-web.xyz/gh/mkproj"
SRC_URI="https://ari-web.xyz/gh/mkproj/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=dev-lang/python-3.8.12_p1-r1
man? ( sys-apps/man-db )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="+man"

DOCS=(README.md)

src_install() {
    dobin mkproj
    use man && (doman mkproj.1 && einstalldocs)
}
