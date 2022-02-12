# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_9 )
inherit distutils-r1

DESCRIPTION="Type Hints for Python"
HOMEPAGE="https://github.com/python/typing"
SRC_URI="https://files.pythonhosted.org/packages/b0/1b/835d4431805939d2996f8772aca1d2313a57e8860fec0e48e8e7dfe3a477/typing-${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/typing-${PV}

LICENSE="CWI"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/python:3.10"
RDEPEND="${DEPEND}"
BDEPEND=""

