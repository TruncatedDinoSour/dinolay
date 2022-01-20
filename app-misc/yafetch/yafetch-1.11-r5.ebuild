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
clang? ( sys-devel/clang )
fonts? ( media-fonts/nerd-fonts )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="config clang +aggressive-pre-strip +fonts"

src_compile() {
    use clang && export CC='clang'
    emake DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" || die "Build failed"
    use aggressive-pre-strip && (STRIPFLAGS='--strip-all -N __gentoo_check_ldflags__ -R .comment -R .GCC.command.line --remove-section=.eh_frame --remove-section=.eh_frame_hdr --remove-section=.gnu.hash --remove-section=.eh_frame_hdr --remove-section=.eh_frame_ptr --remove-section=.note.gnu.gold-version --remove-section=.note.gnu.build-id --remove-section=.note.ABI-tag --remove-section=.note --remove-section=.gnu.version --remove-section=.comment --strip-debug --strip-unneeded' emake strip || die "Stripping failed")
}

src_install() {
    use config && (emake DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" config || die "Copying config file failed")
    emake DESTDIR="${D}/" PREFIX="${EPREFIX}/usr" install || die "Installing failed"
}

pkg_postinst() {
    if ! use config; then
        elog "If you don't have ~/.config/yafetch/init.lua"
        elog "please add USE=config and reemerge the package, after reemerging"
        elog "copy /usr/share/yafetch/init.lua to your config"
    fi
}

