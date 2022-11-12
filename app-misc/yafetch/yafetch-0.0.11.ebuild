# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
LUA_COMPAT=(lua5.4)

DESCRIPTION="Yet another fetch ..."
HOMEPAGE="https://github.com/yrwq/yafetch"
SRC_URI="https://ari-web.xyz/gh/yafetch/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
dev-lang/lua:5.4
fonts? ( media-fonts/nerd-fonts )
"
RDEPEND="${DEPEND}"
BDEPEND="
gcc? ( sys-devel/gcc )
clang? ( sys-devel/clang )
dev-util/pkgconf
sys-devel/make
sys-apps/coreutils
test? (
    sys-apps/coreutils
    dev-util/valgrind
    sys-devel/clang
    dev-lang/lua:5.4
    sys-devel/binutils
    app-shells/bash
    sys-devel/gcc
)
"
IUSE="config clang gcc hardened lto optimised errors \
    +aggressive-pre-strip +fonts test \
    debug debug-log +march"

REQUIRED_USE="
^^ ( clang gcc )
debug? ( !hardened !aggressive-pre-strip !lto !optimised )
"

RESTRICT="debug? ( strip )"

src_configure() {
    use test && bash ./scripts/tests.sh

    local config_flags='--use-warnings'

    use config && config_flags+=" --use-config"
    use clang && config_flags+=" --use-clang"
    use gcc && config_flags+=" --use-gcc"
    use hardened && config_flags+=" --use-harden"
    use lto && config_flags+=" --use-lto"
    use optimised && config_flags+=" --use-optimise"
    use errors && config_flags+=" --use-pedantic --use-werror"
    use aggressive-pre-strip && config_flags+=" --use-strip --use-extreme-strip"
    use debug && config_flags+=" --use-debug"
    use debug-log && config_flags+=" --use-prog-debug"
    use march && config_flags+=" --use-march"

    chmod a+rx ./configure
    ./configure $config_flags || (elog "./configure $config_flags"; die './configure failed')
}

src_compile() {
    DESTDIR="${D}" emake || die 'Compilation failed'
}

src_install() {
    dobin yafetch
    use config && (DESTDIR="${D}/" emake y_config || die 'Cannot install configuration to /usr/share/yafetch/init.lua')
}

pkg_postinst() {
    if ! use config; then
        elog "If you don't have ~/.config/yafetch/init.lua"
        elog "please add USE=config and reemerge the package, after reemerging"
        elog "copy /usr/share/yafetch/init.lua to your config"
    fi
}
