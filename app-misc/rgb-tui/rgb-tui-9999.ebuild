# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Create and get colors code from the terminal using a nice interface."
HOMEPAGE="https://github.com/ArthurSonzogni/rgb-tui"

EGIT_REPO_URI="https://github.com/ArthurSonzogni/rgb-tui"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-util/cmake"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
    git-r3_src_unpack
    EGIT_REPO_URI=$EGIT_REPO_URI_FTXUI
    EGIT_CHECKOUT_DIR=${WORKDIR}/${P}/layer_factory/ftxui
    git-r3_src_unpack
}

src_compile() {
    cmake .
    cmake --build .
}

src_install() {
    mkdir "${D}/usr/bin"
    install -Dm755 "rgb-tui" "${D}/${EPREFIX}/usr/bin"
}

