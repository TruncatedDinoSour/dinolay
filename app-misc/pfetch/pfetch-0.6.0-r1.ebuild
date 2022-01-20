# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A pretty system information tool written in POSIX sh"
HOMEPAGE="https://github.com/dylanaraps/pfetch"
SRC_URI="https://github.com/dylanaraps/pfetch/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
    dobin pfetch
}

