# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/stark/siji.git"
fi

inherit font font-ebdftopcf ${SCM}

DESCRIPTION="An iconic bitmap font based on Stlarch with additional glyphs"
HOMEPAGE="https://github.com/stark/siji"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/stark/siji/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=(Readme.md)
FONT_S=(${S}/bdf)

