# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..10} )

DESCRIPTION="Password tools for generating, checking and rating passwords"
HOMEPAGE="https://ari-web.xyz/gh/pwdtools"
SRC_URI="https://ari-web.xyz/gh/pwdtools/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
dev-python/password-strength
dev-python/pyfzf
dev-python/pyperclip
sys-apps/coreutils
dev-python/plumbum
dev-python/zxcvbn
dev-python/cryptography
man? ( sys-apps/man-db )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="+man doc"

DOCS=(README.md CONTRIBUTING.md doc/extra/md/pdb.md)

src_install() {
    use man && export I_MAN=true
    use doc && export I_DEVMAN=true

    DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" sh ./setup.sh || die 'Installing failed'

    use doc && einstalldocs
}

