# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fuckify your bash commands to the moon and beyond"
HOMEPAGE="https://ari-web.xyz/gh/fuckify"
SRC_URI="https://ari-web.xyz/gh/fuckify/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="unlicense"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
dev-libs/openssl
sys-apps/coreutils
app-shells/bash
app-arch/xz-utils
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin plugin/commands/fuckify
}
