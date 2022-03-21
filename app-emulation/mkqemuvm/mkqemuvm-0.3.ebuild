# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple wrapper around qemu to make virtual machines"
HOMEPAGE="https://ari-web.xyz/gh/mkqemuvm"
SRC_URI="https://github.com/TruncatedDinosour/mkqemuvm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ArAr2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
>=sys-apps/mlocate-0.26
>=app-shells/fzf-0.27.2
>=app-emulation/qemu-6.2.0
>=sys-firmware/edk2-ovmf-202105-r2
>=app-shells/bash-5.1
"
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=(README.md)

src_install() {
    dobin mkqemuvm
    einstalldocs
}
