# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple, modular bash/shell script for configuring your DWM bar."
HOMEPAGE="https://ari-web.xyz/gh/bdwmb"
SRC_URI="https://ari-web.xyz/gh/bdwmb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
>=x11-apps/xsetroot-1.1.2-r1
>=app-shells/bash-5.1_p16
>=sys-apps/coreutils-8.32-r1
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="config"

src_install() {
    emake -j1 full DESTDIR="${D}" PREFIX="${EPREFIX}/usr" CONF="${EPREFIX}/usr/share/bdwmb" || die "Installation failed"
    if use config; then
        emake -j1 config DESTDIR="${D}" CONF="${EPREFIX}/usr/share/bdwmb" || die "Installing configuration failed"
    fi
}

pkg_postinst() {
    if ! use config; then
        elog "If you don't have ~/.config/bdwmb please add USE=config"
        elog "reemerge the package and take it from /usr/share/bdwmb/config.sh"
    fi
}

