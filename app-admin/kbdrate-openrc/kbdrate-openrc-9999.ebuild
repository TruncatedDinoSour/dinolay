# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Change keyboard rate on boot"
HOMEPAGE="https://ari-web.xyz/gh/kbdrate"
EGIT_REPO_URI="https://github.com/TruncatedDinosour/kbdrate.git"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=sys-apps/kbd-2.4.0
>=sys-apps/openrc-0.44.10
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    newconfd openrc/kbdrate.confd kbdrate
    newinitd openrc/kbdrate.rc kbdrate
}
