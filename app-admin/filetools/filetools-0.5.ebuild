# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

DESCRIPTION="Tools for getting, inspecting and validating files and their information"
HOMEPAGE="https://ari-web.xyz/gh/filetools"
SRC_URI="https://ari-web.xyz/gh/filetools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
dev-python/python-magic
man? ( sys-apps/man-db )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="+man doc"

DOCS=(README.md)

src_install() {
    chmod a+rx ./setup.sh
    DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" ./setup.sh || die 'Installing failed'

    use doc && einstalldocs
}

