# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="A simple SUID tool written in C++"
HOMEPAGE="https://ari-web.xyz/gh/kos"
SRC_URI="https://ari-web.xyz/gh/kos/archive/refs/tags/v$PV.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=sys-libs/libxcrypt-4.4.27
acct-group/kos
man? ( sys-apps/man-db )
bash-completion? ( app-shells/bash-completion )
"
RDEPEND="${DEPEND}"
BDEPEND="
gcc? ( sys-devel/gcc[cxx] )
vtable-harden-gcc? ( sys-devel/gcc[vtv] )
clang? ( sys-devel/clang )
>=dev-util/pkgconf-1.8.0-r1
valgrind? ( dev-util/valgrind app-shells/bash )
test? ( sys-devel/gcc sys-devel/clang sys-apps/coreutils sys-apps/net-tools app-shells/bash )
"

IUSE="gcc +strip +man bash-completion doc
      +clang +size debug +group-inherit
      +setenv speed lto test +flags
      unsafe-group-validation unsafe-password-validation
      +safe hardened unsafe-password-echo valgrind quiet
      infinite-ask no-bypass-root-auth stable +no-pipe
      vtable-harden-gcc branch-harden-gcc fcf-harden-gcc
      +no-remember-auth short-grace-time"
REQUIRED_USE="
^^ ( clang gcc )
?? ( size debug )
clang? ( !vtable-harden-gcc !branch-harden-gcc !fcf-harden-gcc )
debug? ( !strip !speed !lto )
safe? ( !unsafe-group-validation !unsafe-password-validation !unsafe-password-echo )
hardened? ( safe no-pipe !speed !strip !size !lto )
stable? ( !no-bypass-root-auth !no-pipe )
vtable-harden-gcc? ( gcc hardened )
gcc? (
    hardened? (
        ?? ( branch-harden-gcc fcf-harden-gcc )
    )
)
short-grace-time? ( !no-remember-auth )
"

RESTRICT="
debug? ( strip )
strip? ( strip )
hardened? ( strip )
"

DOCS=(README.md TODO.md kos.1 LICENSE)

_del_config() {
    echo "DEL_CONFIG: Disabling feature: $1"
    sed "/#define HAVE_$1/d" -i src/config.h
}

_set_config() {
    echo "SET_CONFIG: Changing feature: $1=$2"
    sed "s/$1.*/$1=$2;/" -i src/config.h
}

ilog() {
    ${2:-ewarn} "    $1"
}

src_configure() {
    export CXXFLAGS="${CXXFLAGS} -D_KOS_VERSION_=\"$PV\""

    if use hardened; then
        export LDFLAGS="$LDFLAGS -Wl,-z,relro,-z,now,-z,noexecstack"

        CXXFLAGS+=" -D_FORTIFY_SOURCE=2 -fstack-protector-all
        -fstack-protector-strong -fPIE -pie
        -Wno-unused-result -Wno-unused-command-line-argument
        -O2 -Werror=format-security -Wconversion -Wsign-conversion
        --param ssp-buffer-size=4 -fstack-clash-protection -ftrapv -g0"

        use clang && CXXFLAGS+=" -arch x86_64 -mharden-sls=all -fcf-protection=full"

        if use gcc; then
            if use branch-harden-gcc; then
                CXXFLAGS+=" -mindirect-branch=thunk -mfunction-return=thunk"
            elif use fcf-harden-gcc; then
                CXXFLAGS+=" -fcf-protection=full"
            fi
        fi

        use vtable-harden-gcc && CXXFLAGS+=" -fvtable-verify=std"
    fi

    use test && bash ./scripts/test/noroot.sh
    use valgrind && bash ./scripts/test/valgrind.sh

    use gcc && export CXX=g++

    use size && CXXFLAGS+=" -Os -s"
    use debug && CXXFLAGS+=" -Og -g"
    use speed && CXXFLAGS+=" -O2"

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

    use infinite-ask || _del_config INFINITE_ASK

    use no-bypass-root-auth && _set_config SKIP_ROOT_AUTH 0

    use no-pipe && _del_config PIPE

    use no-remember-auth && _del_config REMEMBERAUTH
    use short-grace-time && _set_config GRACE_TIME 60
}

src_compile() {
    sh ./scripts/build.sh || die 'Building failed'

    if use strip; then
        sh ./scripts/strip.sh kos || die 'Stripping failed'
    fi
}

src_install() {
    insinto /usr/bin
    doins kos
    fperms 4711 /usr/bin/kos

    use man && doman kos.1
    use bash-completion && newbashcomp completions/kos.bash "${PN}"
    use doc && einstalldocs
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
    use debug && use hardened && ewarn 'Hardening with debug enabled which disables Fortify'

    if use hardened; then
        use gcc && ! use vtable-harden-gcc && ewarn 'While using GCC USE=vtable-harden-gcc is suggested'
    fi
}
