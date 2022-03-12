# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

DESCRIPTION="Small CLI colour picker written in python"
HOMEPAGE="https://ari-web.xyz/gh/colourpicker"
SRC_URI="https://github.com/TruncatedDinosour/colourpicker/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
dev-lang/python[tk,readline]
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin colourpicker
}

