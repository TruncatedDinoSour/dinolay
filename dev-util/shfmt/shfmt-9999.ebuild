# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck shell=sh # Written to be posix compatible
# shellcheck disable=SC2148,SC2034,SC3030

EAPI="7"

inherit git-r3

EGIT_REPO_URI="https://github.com/mvdan/sh.git"

DESCRIPTION="A shell parser and formatter for POSIX shell and bash"
HOMEPAGE="https://github.com/mvdan/sh"

LICENSE="BSD"
SLOT="0"
IUSE="man"
RESTRICT="test network-sandbox"

DEPEND="
	dev-lang/go
"
BDEPEND="
	man? (
		app-text/scdoc
	)
"
RDEPEND="
	$DEPEND
	!dev-util/$PN-bin
"

src_compile() {
	go build -v -o "$PN" "./cmd/$PN"
	use man && scdoc < ./cmd/"$PN"/"$PN".1.scd > "$PN".1
}

src_install() {
	use man && doman "$PN".1

	dobin "$PN"
}
