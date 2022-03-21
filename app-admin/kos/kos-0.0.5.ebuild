# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="A simple SUID tool written in C++"
HOMEPAGE="https://ari-web.xyz/gh/kos"
SRC_URI="https://github.com/TruncatedDinosour/kos/archive/refs/tags/v$PV.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=sys-libs/libxcrypt-4.4.27
>=dev-util/pkgconf-1.8.0-r1
acct-group/kos
man? ( sys-apps/man-db )
gcc? ( sys-devel/gcc ) || ( sys-devel/clang )
bash-completion? ( app-shells/bash-completion )
"
RDEPEND="${DEPEND}"
BDEPEND=""
IUSE="gcc strip man bash-completion"

src_compile() {
    use gcc && export CXX=g++
    sh ./scripts/build.sh

    use strip && sh ./scripts/strip.sh kos
}

src_install() {
    insinto /usr/bin
    doins kos
    fperms 4711 /usr/bin/kos

    use man && doman kos.1
    use bash-completion && newbashcomp completions/kos.bash ${PN}
}

pkg_postinst() {
    ewarn 'Make sure to add yourself and other members to the'
    ewarn '`kos` group to be able to use kos, it might not exist'
    ewarn 'so you might need to create it:'
    ewarn '    $ su'
    ewarn '    # groupadd kos'
    ewarn
    ewarn 'And to add yourself to the group:'
    ewarn '    # usermod -aG kos some_system_user'
}
