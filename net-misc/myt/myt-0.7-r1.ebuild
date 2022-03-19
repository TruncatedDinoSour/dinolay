# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="tool for watching videos on youtube with no spyware and MPV and yt-dlp"
HOMEPAGE="https://ari-web.xyz/gh/myt"
SRC_URI="https://github.com/TruncatedDinosour/myt/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=dev-lang/python-3.9.9-r1[readline]
>=dev-python/configparser-5.2.0
>=dev-python/requests-2.26.0
>=dev-python/colorama-0.4.4
>=dev-python/python-mpv-0.5.2
>=dev-python/plumbum-1.7.2
>=dev-python/pyfzf-0.2.2
>=net-misc/yt-dlp-2022.1.21
dev-lang/python[readline]
media-video/mpv[libmpv]
man? ( >=sys-apps/man-db-2.9.4-r1 )
test? (
>=dev-python/pycodestyle-2.8.0
>=dev-python/pyflakes-2.4.0
>=dev-python/isort-5.10.1
>=dev-python/mypy-0.930
>=dev-python/black-21.12_beta0
>=dev-python/flake8-4.0.1-r1
>=dev-python/pylint-2.12.2
>=app-misc/man-to-md-0.14.1
)
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="+man test"

src_test() {
    if use test; then
        sh scripts/test.sh || die "Tests failed"
    fi
}

src_install() {
    dobin src/myt
    use man && (doman doc/myt.1 || die 'Failed to install man page')
}

