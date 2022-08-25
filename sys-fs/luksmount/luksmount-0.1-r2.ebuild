# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple and safe wrapper around cryptsetup written in bash"
HOMEPAGE="https://ari-web.xyz/gh/luksmount"
SRC_URI="https://ari-web.xyz/gh/luksmount/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=app-shells/bash-5.1_p8
>=sys-fs/cryptsetup-2.4.3
>=sys-apps/coreutils-8.32-r1
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin luksmount
}
