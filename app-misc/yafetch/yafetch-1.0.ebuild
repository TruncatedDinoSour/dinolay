# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Yet another fetch ..."
HOMEPAGE="https://github.com/yrwq/yafetch"
SRC_URI="https://github.com/TruncatedDinosour/yafetch/archive/refs/tags/v${PV}.tar.gz -> ${PN}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="=dev-lang/lua-5.4.2-r1"
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	emake
}

src_install() {
	default

	if use config; then
		emake config
	fi

	emake install
}

pkg_postinst() {
	einfo "If you don't have ~/.config/yafetch/init.lua please add USE=config and reemerge the package"
}

