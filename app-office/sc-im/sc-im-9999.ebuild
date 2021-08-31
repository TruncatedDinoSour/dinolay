# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/andmarti1424/sc-im.git"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_BRANCH="freeze"
	SRC_URI=""
	KEYWORDS=""
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/andmarti1424/sc-im/archive/v${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${P}"
fi

DESCRIPTION="Spreadsheet Calculator Improvised"
HOMEPAGE="https://github.com/andmarti1424/sc-im"

SLOT="0"
LICENSE="BSD"
IUSE="docs lua gnuplot xls tmux xclip"
KEYWORDS="amd64 ppc sparc x86"

COMMON_DEPEND="
	>=sys-libs/ncurses-5.2
"
DEPEND="
	virtual/pkgconfig
"
RDEPEND="
	${COMMON_DEPEND}
	docs? ( app-doc/doxygen )
	lua? ( dev-lang/lua )
	gnuplot? ( sci-visualization/gnuplot )
	xls? ( dev-libs/libxls dev-libs/libxlsxwriter dev-libs/libxml2 dev-libs/libzip )
	tmux? ( app-misc/tmux )
	xclip? ( x11-misc/xclip )
"

src_prepare() {
	default
	cd "${S}"/src
	sed -i "s|/usr/local|/usr|g" Makefile || die "Failed to set prefix in Makefile"

	if use gnuplot; then
	echo "Building with gnuplot support"
	else
	sed -i "/-DGNUPLOT/d" Makefile || die "Failed to disable GNUPLOT in Makefile"
	fi

	if use xls; then
	echo "Building with XLS write support"
	else
	sed -i "/-DXLSX/d" Makefile &&
    sed -i "/-lxlsxwriter/d" Makefile &&
    sed -i "/libs libxml-2.0 libzip/d" Makefile || die "Failed to disable XLS write support in Makefile"
	fi

	if use xclip; then
	sed -i 's/"tmux load-buffer"/"xclip -i -selection clipboard <"/g' Makefile &&
    sed -i 's/"tmux show-buffer"/"xclip -o -selection clipboard"/g' Makefile ||
    die "Failed to set xclip support in Makefile"
	fi


	eapply_user
}

src_compile() {
    cd "${S}"/src
	tc-export PKG_CONFIG
	# no autoconf
	emake prefix="${D}"/usr
}

src_install() {
	cd "${S}"/src
	dodir /usr/bin
	dodir /usr/$(get_libdir)/sc-im
	dodir /usr/share/man/man1

	emake DESTDIR="${D}" install

	doman sc-im.1
}

