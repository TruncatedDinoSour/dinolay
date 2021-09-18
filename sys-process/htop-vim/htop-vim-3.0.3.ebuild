# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="htop is an interactive text-mode process viewer for Linux."
HOMEPAGE="https://github.com/KoffeinFlummi/htop-vim"
SRC_URI="https://github.com/KoffeinFlummi/htop-vim/archive/refs/tags/${PV}vim.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/ncurses"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	./configure --prefix=/usr
	emake
	emake install
}

