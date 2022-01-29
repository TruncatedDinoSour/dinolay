# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Password strength and validation"
HOMEPAGE="https://github.com/kolypto/py-password-strength"
SRC_URI="https://github.com/kolypto/py-password-strength/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/py-password-strength-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
