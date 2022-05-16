# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="A lightweight plugin manager for GNU bash"
HOMEPAGE="https://ari-web.xyz/gh/baz"
SRC_URI="https://github.com/TruncatedDinosour/baz/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
sys-apps/coreutils
dev-vcs/git
app-shells/bash
readline? ( app-misc/rlwrap )
bash-completion? ( app-shells/bash-completion )
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="readline +bash-completion doc"

DOCS=(README.md PLUGINS.md doc/BAZ_ENV.md doc/PLUGIN_FOLDER_STRUCTURE.md)

src_compile() {
    tee baz_setup <<EOF
#!/usr/bin/env sh

set -e

log() { echo "[GENTOO] \$1"; }

main() {
    log 'Setting up baz'
    log 'Entering /tmp'
    cd /tmp

    log 'Getting loader template'
    cp /usr/share/baz/baz_loader.sht .

    log 'Installing/setting up baz'
    baz setup

    log 'Removing template'
    rm -f -- baz_loader.sht
    log 'Done!'
}

main "$@"
EOF
}

src_install() {
    insinto /usr/share/baz
    doins baz_loader.sht

    dobin baz_setup
    dobin baz

    use bash-completion && newbashcomp completions/baz.bash ${PN}
    use doc && einstalldocs
}

pkg_postinst() {
    eerror 'After installation do this to set up baz completely:'
    eerror '    $ baz_setup'
}
