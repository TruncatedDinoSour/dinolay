# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple SUID tool written in C++"
HOMEPAGE="https://ari-web.xyz/gh/kos"
SRC_URI="https://github.com/TruncatedDinosour/kos/archive/refs/tags/v$PV.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=sys-libs/libxcrypt-4.4.27
>=dev-util/pkgconf-1.8.0-r1
man? ( sys-apps/man-db )
gcc? ( sys-devel/gcc ) || ( sys-devel/clang )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="gcc strip man"

src_compile() {
    use gcc && export CXX=g++
    DESTDIR="$D/" sh ./scripts/build.sh

    use strip && sh ./scripts/strip.sh "$D/kos"
}

src_install() {
    fperms 4711 "$D/kos"
    insinto /usr/bin
    doins "$D/kos"
    fperms 4711 "/usr/bin/kos"

    use man && doman "kos.1"
}
