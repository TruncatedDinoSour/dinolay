# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

DESCRIPTION="Type Hints for Python"
HOMEPAGE="https://github.com/python/typing"
SRC_URI="https://github.com/python/typing/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/typing-${PV}

LICENSE="CWI"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

