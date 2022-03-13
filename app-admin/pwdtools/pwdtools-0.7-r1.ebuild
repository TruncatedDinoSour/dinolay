# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..10} )

DESCRIPTION="Password tools for generating, checking and rating passwords"
HOMEPAGE="https://ari-web.xyz/gh/pwdtools"
SRC_URI="https://github.com/TruncatedDinosour/pwdtools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
dev-python/password-strength
dev-python/pyfzf
dev-python/pyperclip
sys-apps/coreutils
dev-python/plumbum
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

