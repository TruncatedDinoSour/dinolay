# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU APL is a free implementation of APL."

HOMEPAGE="https://www.gnu.org/software/apl/"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"

IUSE="nls lapack readline extras doc vim-syntax"

DEPEND="nls? ( sys-devel/gettext )
lapack? ( virtual/lapack )
readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"
BDEPEND=""

# use default src_unpack

src_configure() {
    econf $(use_enable nls) \
      $(use lapack) \
      $(use_with readline)
}

src_install() {
    # likely be better to have it installed as gnu-apl or gnu-apl-1.4,
    # currently installed as apl
    emake DESTDIR="${D}" install

    # additional programs under ./tools
    if use extras; then
        # this program is useful, but is not installed by the Makefile
        dobin tools/APL_keyboard_learn
    fi

    # a vim mode in ./support-files
    if use vim-syntax; then
        insinto /usr/share/vim/vimfiles/syntax/
        doins support-files/apl.vim
    fi
    # emacs mode at https://github.com/lokedhs/gnu-apl-mode
}

pkg_postinst() {
    # documentation gets installed automatically by the Makefile in /usr/share/doc/apl
    if ! use doc; then
        # TODO /usr/share/doc is brittle; change
        rm -r /usr/share/doc/apl/* || die
    fi

    if ! use extras; then
        # installed automatically by GNU APL's Makefile is APserver, AP100, and AP210
        rm /usr/bin/APserver || die
        rm /usr/bin/AP100 || die
        rm /usr/bin/AP210 || die
    fi
}
