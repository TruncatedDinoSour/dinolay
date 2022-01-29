# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="A python wrapper for fzf"
HOMEPAGE="https://github.com/nk412/pyfzf"
SRC_URI="https://github.com/nk412/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-shells/fzf
dev-python/plumbum[${PYTHON_USEDEP}]
"

