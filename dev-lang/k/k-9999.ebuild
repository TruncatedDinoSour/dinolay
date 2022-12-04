# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A simple and fast vector programming language"
HOMEPAGE="https://codeberg.org/ngn/k"

EGIT_REPO_URI="https://codeberg.org/ngn/k.git"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
clang? ( sys-devel/clang )
!clang? ( sys-devel/gcc )
sys-devel/make

vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )
vim-ft? ( || ( app-editors/vim app-editors/gvim ) )
vim-ftp? ( || ( app-editors/vim app-editors/gvim ) )
"

IUSE="test clang +vim-syntax vim-ft vim-ftp +repl +libs headers"

src_compile() {
    use clang && export CC=clang

    if use test; then
        emake
    else
        emake k
    fi

    if use repl; then
        sed '1 s/.*/#!\/usr\/bin\/env k/' -i repl.k
        mv repl.k krepl
    fi
}

src_install() {
    dobin k
    use repl && dobin krepl

    if use vim-syntax; then
        insinto /usr/share/vim/vimfiles/syntax
        doins vim-k/syntax/* vim-c/syntax/*
    fi

    if use vim-ft; then
        insinto /usr/share/vim/vimfiles/ftdetect
        doins vim-k/ftdetect/* vim-c/ftdetect/*
    fi

    if use vim-ftp; then
        insinto /usr/share/vim/vimfiles/ftplugin
        doins vim-k/ftplugin/* vim-c/ftplugin/*
    fi

    if use libs; then
        insinto /usr/lib/k
        doins l/*
    fi

    if use headers; then
        insinto /usr/include/k
        doins *.c *.h
    fi
}
