# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Show installed, orphaned and total packages in a small shellscript fetch tool"
HOMEPAGE="https://ari-web.xyz/gh/portage-show"
SRC_URI="https://github.com/TruncatedDinosour/portage-show/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
sys-apps/portage
app-portage/portage-utils
sys-apps/grep
sys-apps/coreutils
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin portage-show
}
