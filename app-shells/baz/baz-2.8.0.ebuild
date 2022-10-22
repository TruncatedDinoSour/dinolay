# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="A lightweight plugin manager for GNU bash"
HOMEPAGE="https://ari-web.xyz/gh/baz"
SRC_URI="https://ari-web.xyz/gh/baz/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
sys-apps/coreutils
dev-vcs/git
app-shells/bash
readline? ( app-misc/rlwrap )
bash-completion? ( app-shells/bash-completion )
gcc? ( sys-devel/gcc )
clang? ( sys-devel/clang )
"
REQUIRED_USE="
baz-cat? (
    ^^ ( clang gcc )
)
baz-cat-flush? ( baz-cat )
"

RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="readline +bash-completion doc gcc +clang +baz-cat baz-cat-flush"

DOCS=(README.md PLUGINS.md doc/BAZ_ENV.md doc/PLUGIN_FOLDER_STRUCTURE.md doc/SANITIZATION.md doc/CONFIGURATION_FILES.md)

src_compile() {
    export BAZ_CAT='cat'

    if use baz-cat; then
        export BAZ_CAT='baz-cat'
        export CFLAGS=''

        if use gcc; then
            export CC='gcc'
        elif use clang; then
            export CC='clang'
        else
            die 'Failed to set CC'
        fi

        use baz-cat-flush && export CFLAGS='-DMANUAL_FLUSH'

        sh ./scripts/baz-cat-build.sh
    fi

    tee baz-setup <<EOF
#!/usr/bin/env sh

set -e

log() { echo "[GENTOO] \$1"; }

main() {
    log 'Setting up baz'
    export BAZ_CAT='$BAZ_CAT'

    log 'Entering /tmp'
    cd /tmp

    log 'Getting loader template'
    cp /usr/share/baz/loader.sht .

    log 'Installing/setting up baz'
    baz setup

    log 'Removing template'
    rm -f -- loader.sht
    log 'Done!'
}

main
EOF
}

src_install() {
    insinto /usr/share/baz
    doins loader.sht

    dobin baz-setup
    dobin baz

    use baz-cat && dobin baz-cat

    use bash-completion && newbashcomp completions/baz.bash ${PN}
    use doc && einstalldocs
}

pkg_postinst() {
    eerror 'After installation do this to set up baz completely:'
    eerror '    $ baz-setup'
    echo
    eerror 'If you uninstall baz, after uninstalling the bin remember to:'
    eerror '    $ rm -rf ~/.local/share/baz'

    if ! use baz-cat; then
        echo
        ewarn 'USE=baz-cat is recommended for performance'
    fi
}
