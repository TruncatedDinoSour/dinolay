# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Manage, switch and template licenses"
HOMEPAGE="https://ari-web.xyz/gh/lmgr"
SRC_URI="https://ari-web.xyz/gh/lmgr/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=sys-apps/coreutils-8.32-r1
>=sys-libs/ncurses-6.2_p20210619
>=app-shells/fzf-0.27.2
>=dev-vcs/git-2.34.1
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin lmgr
}
