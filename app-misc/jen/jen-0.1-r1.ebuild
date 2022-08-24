# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Jen"
HOMEPAGE="https://ari-web.xyz/"
SRC_URI="https://files.ari-web.xyz/files/bin.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
    default
    mv bin "$P"
}

src_compile() {
    sed 's/MESSAGE_HERE/Jen/' -i bin
    mv bin jen
}

src_install() {
    dobin jen
}
