# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{6..10} )
inherit distutils-r1

DESCRIPTION="Advanced directory tree synchronisation tool"
HOMEPAGE="https://pypi.org/project/dirsync/"
SRC_URI="https://github.com/tkhyn/dirsync/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/dirsync-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

