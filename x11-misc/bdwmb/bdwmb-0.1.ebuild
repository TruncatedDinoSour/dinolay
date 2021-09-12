# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple, modular bash/shell script for configuring your DWM bar."
HOMEPAGE="https://github.com/TruncatedDinosour/bdwmb"
SRC_URI="https://github.com/TruncatedDinosour/bdwmb/archive/refs/tags/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
x11-apps/xsetroot
app-shells/bash
"
RDEPEND="${DEPEND}"
BDEPEND=""


src_install() {
	make PREFIX=/usr full
}
