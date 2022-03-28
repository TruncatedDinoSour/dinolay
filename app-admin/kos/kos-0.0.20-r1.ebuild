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
valgrind? ( dev-util/valgrind app-shells/bash )
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="gcc strip +man bash-completion doc
      +clang +size debug +group-inherit
      +setenv speed lto test +flags
      unsafe-group-validation unsafe-password-validation
      +safe hardened unsafe-password-echo valgrind quiet"
REQUIRED_USE="
^^ ( clang gcc )
?? ( size debug )
debug? ( !strip !speed !lto )
safe? ( !unsafe-group-validation !unsafe-password-validation !unsafe-password-echo )
hardened? ( safe lto speed )
"

RESTRICT="
debug? ( strip )
strip? ( strip )
"

DOCS=(README.md TODO.md kos.1 LICENSE)

_del_config() {
    sed "/HAVE_$1/d" -i src/config.h
}

ilog() {
    ${2:-ewarn} "    $1"
}

src_configure() {
    export CXXFLAGS="${CXXFLAGS} -D_KOS_VERSION_=\"$PV\""

    use hardened && CXXFLAGS+=" -fstack-protector-strong -fstack-protector -fPIE -pie -D_FORTIFY_SOURCE=2 \
        -Wno-unused-result -Wno-unused-command-line-argument"

    use test && bash ./scripts/test/noroot.sh
    use valgrind && bash ./scripts/test/valgrind.sh

    use gcc && export CXX=g++

    use size && CXXFLAGS+=" -Os -s"
    use debug && CXXFLAGS+=" -Og -g"
    use speed && CXXFLAGS+=" -Ofast -ffast-math -Wl,-O3"

    use lto && CXXFLAGS+=" -flto"

    use group-inherit || _del_config INITGROUP
    use setenv || _del_config MODIFYENV

    if ! use flags; then
        _del_config ARG
        sed 's/COMPREPLY=.*$/return # USE=-flags/' -i completions/kos.bash
    fi

    use quiet && _del_config LOGGING

    use unsafe-password-validation &&  _del_config VALIDATEPASS
    use unsafe-group-validation && _del_config VALIDATEGRP
    use unsafe-password-echo && _del_config NOECHO
}

src_compile() {
    sh ./scripts/build.sh || die 'Building failed'
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
    elog 'Make sure to add yourself and other members to the'
    elog '`kos` group to be able to use kos, it might not exist'
    elog 'so you might need to create it:'
    elog '    $ su'
    elog '    # groupadd kos'
    elog
    elog 'And to add yourself to the group:'
    elog '    # usermod -aG kos some_system_user'

    if use unsafe-group-validation ||
        use unsafe-password-validation ||
        use unsafe-password-echo; then
        echo
        eerror '!! Unsafe USE flags detected: '

        use unsafe-group-validation && ilog 'unsafe-group-validation: this flag makes that any user can run kos without being in the kos group'
        use unsafe-password-validation && ilog 'unsafe-password-validation: this flag makes that any user can run kos without needing to know the password'
        use unsafe-password-echo && ilog 'unsafe-password-echo: this flag makes that the password can be echoed instead of being hidden'

        eerror 'please make sure that you actually want that behaviour'
        eerror 'else disable that/those USE flag(s) and recompile kos'

        ilog 'I suggest you enable `safe` USE flag to prevent this from happening again' eerror
    fi

    use test && ! use valgrind && (echo && ewarn 'USE=test enabled, but no valgrind enabled which is highly recomended')
}
