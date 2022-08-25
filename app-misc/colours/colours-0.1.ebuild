# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A (fetch?) tool to display the colours of your terminal emulator written in bash"
HOMEPAGE="https://ari-web.xyz/gh/colours"
SRC_URI="https://ari-web.xyz/gh/colours/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=app-shells/bash-5.1_p8
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin colours
}
