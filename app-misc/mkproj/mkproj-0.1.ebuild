# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{3..10} )

DESCRIPTION="Make and use templates for projects"
HOMEPAGE="https://ari-web.xyz/gh/mkproj"
SRC_URI="https://github.com/TruncatedDinosour/mkproj/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/python-3.8.12_p1-r1"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="+man"

DOCS=(README.md)

src_install() {
    dobin mkproj
    use man && (einstalldocs && doman mkproj.1)
}
