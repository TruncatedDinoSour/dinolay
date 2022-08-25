# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SearX in the CLI"
HOMEPAGE="https://ari-web.xyz/gh/searx-cli"
SRC_URI="https://ari-web.xyz/gh/searx-cli/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=dev-python/pyfzf-0.2.2
>=dev-python/requests-2.27.1
>=dev-python/configparser-5.2.0
>=dev-python/beautifulsoup4-4.10.0
man? ( sys-apps/man-db )
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="+man doc"

src_install() {
    dobin src/sxcl
    use man && doman doc/sxcl.1
    use doc && dodoc README.md
}

pkg_postinst() {
    elog 'Installed searx-cli, run `sxcl config` to generate new config'
}
