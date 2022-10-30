# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A dead-simple shellscript around scrot and mpv for taking screenshots"
HOMEPAGE="https://ari-web.xyz/gh/shot"
SRC_URI="https://ari-web.xyz/gh/shot/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
sys-apps/coreutils
>=media-gfx/scrot-1.4
>=media-video/mpv-0.33.1-r2
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin shot
}

