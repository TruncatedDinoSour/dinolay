# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="a fast, easy, simple and lightweight plugin manager for GNU bash"
HOMEPAGE="https://ari-web.xyz/gh/baz"
SRC_URI="https://ari-web.xyz/gh/baz/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
dev-vcs/git
app-shells/bash
readline? ( app-misc/rlwrap )
bash-completion? ( app-shells/bash-completion )
"

RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="readline +bash-completion doc logging ok nocc"

DOCS=(README.md PLUGINS.md doc/BAZ_ENV.md doc/PLUGIN_FOLDER_STRUCTURE.md doc/SANITIZATION.md doc/CONFIGURATION_FILES.md doc/LOADER.md)

src_compile() {
    logging_export='# USE="-logging"'
    ok_export='# USE="-ok"'
    nocc_export='# USE="-nocc"'

    use logging && logging_export='export BAZ_LOGGING_ENABLED=true'
    use ok && ok_export='export BAZ_ENSURE_OK=true'
    use nocc && nocc_export='export BAZ_NO_CC=true'

    tee baz-setup <<EOF
#!/usr/bin/env sh

set -e

log() { echo "[GENTOO] \$1"; }

main() {
    local s="\$HOME/.config/baz/genoo-cflags.env"

    log 'note : for custom build flags set up the CC, CFLAGS, STRIP and STRIPFLAGS env vars manually, https://ari-web.xyz/gh/baz#setup'
    log "you can put them in \$s"
    sleep 2

    log 'setup will begin soon'
    sleep 2

    if [ -f "\$s" ]; then
        log "sourcing \$s"
        . "\$s"
    fi

    log 'setting up baz'
    $logging_export
    $ok_export
    $nocc_export

    log 'entering tmp dir'
    cd "\${TMPDIR:-/tmp/}"

    log 'initial cleanup'
    rm -rf -- baz

    log 'getting loader templates'
    cp -r /usr/share/baz/ .
    cd baz/

    log 'installing / setting up baz'
    baz setup

    log 'removing templates from tmp'
    cd ..
    rm -rf -- baz/
    log 'done !'
}

main
EOF
}

src_install() {
    insinto /usr/share/baz
    doins loader.sht

    mkdir -p "${D}/${EPREFIX}/usr/share/baz/loader"

    for f in loader/*; do
        install -Dm644 "$f" "${D}/${EPREFIX}/usr/share/baz/loader"
    done

    dobin baz-setup
    dobin baz

    use bash-completion && newbashcomp completions/baz.bash ${PN}
    use doc && einstalldocs
}

pkg_postinst() {
    ewarn 'after installation do this to set up baz completely :'
    ewarn '    $ baz-setup'
}

pkg_postrm() {
    ewarn 'if youre uninstalling baz completely from your system, to fully uninstall baz run :'
    ewarn '    $ rm -rf ~/.local/share/baz'
}
