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
gcc? ( sys-devel/gcc )
clang? ( sys-devel/clang )
bash-completion? ( app-shells/bash-completion )
test? ( sys-devel/gcc sys-devel/clang sys-apps/coreutils sys-apps/net-tools app-shells/bash )
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="gcc strip +man bash-completion doc
      +clang +size debug +group-inherit
      +setenv speed lto test +flags"
REQUIRED_USE="
^^ ( clang gcc )
?? ( size debug )
debug? ( !strip !speed !lto )
"

RESTRICT="
debug? ( strip )
strip? ( strip )
"

DOCS=(README.md TODO.md kos.1 LICENSE)

_del_config() {
    sed "/HAVE_$1/d" -i src/config.h
}

src_configure() {
    export CXXFLAGS="${CXXFLAGS} -D_KOS_VERSION_=\"$PV\""

    use test && bash ./scripts/test/noroot.sh

    use gcc && export CXX=g++

    use size && CXXFLAGS+=" -Os -s"
    use debug && CXXFLAGS+=" -Og -g"
    use speed && CXXFLAGS+=" -Ofast -ffast-math -Wl,-O3"

    use lto && CXXFLAGS+=" -flto"

    use group-inherit || _del_config INITGROUP
    use setenv || _del_config MODIFYENV
    use flags || _del_config ARG
}

src_compile() {
    sh ./scripts/build.sh
}

src_install() {
    insinto /usr/bin
    doins kos
    fperms 4711 /usr/bin/kos

    use man && doman kos.1
    use bash-completion && newbashcomp completions/kos.bash ${PN}
    use doc && einstalldocs
}

pkg_preinst() {
    use strip && sh ./scripts/strip.sh kos
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
