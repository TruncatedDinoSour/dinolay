# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Yet another fetch ..."
HOMEPAGE="https://github.com/yrwq/yafetch"
SRC_URI="https://github.com/TruncatedDinosour/yafetch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/lua:5.4"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="config"

src_compile() {
  emake DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" || die "Build failed"
  emake strip || die "Stripping failed"
}

src_install() {
  if use config; then
    emake DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" config || die "Copying config file failed"
  fi

  emake DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" install || die "Installing failed"
}

pkg_postinst() {
  if ! use config; then
    elog "If you don't have ~/.config/yafetch/init.lua"
    elog "please add USE=config and reemerge the package, after reemerging"
    elog "copy /usr/share/yafetch/init.lua to your config"
  fi
}

