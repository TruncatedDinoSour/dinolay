# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage, make and use char-sets"
HOMEPAGE="https://ari-web.xyz/gh/char"
SRC_URI="https://github.com/TruncatedDinosour/char/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=dev-lang/python-3.9.9
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin char
}
