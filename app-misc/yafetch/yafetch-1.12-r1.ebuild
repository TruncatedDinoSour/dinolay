# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Yet another fetch ..."
HOMEPAGE="https://github.com/yrwq/yafetch"
SRC_URI="https://github.com/TruncatedDinosour/yafetch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
dev-lang/lua:5.4
dev-util/pkgconf
sys-devel/make
clang? ( sys-devel/clang )
!clang? ( sys-devel/gcc )
fonts? ( media-fonts/nerd-fonts )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="config clang hardened lto optimised errors +aggressive-pre-strip +fonts"

src_configure() {
    local config_flags='--use-warnings'

    use config && config_flags+=" --use-config"
    use clang && config_flags+=" --use-clang"
    use hardened && config_flags+=" --use-harden"
    use lto && config_flags+=" --use-lto"
    use optimised && config_flags+=" --use-optimise"
    use errors && config_flags+="--use-pedantic --use-werror"
    use aggressive-pre-strip && config_flags+=" --use-strip --use-extreme-strip"

    ./configure $config_flags || die './config failed'
}

src_compile() {
    emake || die 'Compilation failed'
}

src_install() {
    dobin yafetch
}

pkg_postinst() {
    if ! use config; then
        elog "If you don't have ~/.config/yafetch/init.lua"
        elog "please add USE=config and reemerge the package, after reemerging"
        elog "copy /usr/share/yafetch/init.lua to your config"
    fi
}
