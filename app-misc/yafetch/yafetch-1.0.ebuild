# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SRC_URI="https://github.com/TruncatedDinosour/yafetch/archive/refs/tags/v${PV}.tar.gz"
DESCRIPTION="Yet another fetch ..."
HOMEPAGE="https://github.com/yrwq/yafetch"
LICENSE="MIT"
SLOT="0"
KEYW0RDS="~amd64"

src_prepare() {
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" all install
}

