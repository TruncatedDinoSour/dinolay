# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage, make and use char-sets"
HOMEPAGE="https://ari-web.xyz/gh/cran"
SRC_URI="https://github.com/TruncatedDinosour/cran/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=dev-lang/R-4.0.5
>=app-shells/bash-5.1
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="+man"

DOCS=(README.md)

src_install() {
    dobin cran
    use man && (doman doc/cran.1 && einstalldocs)
}

