# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_PN="github.com/muesli/${PN}"

EGO_SUM=(
    "github.com/davecgh/go-spew v1.1.1"
    "github.com/davecgh/go-spew v1.1.1/go.mod"
    "github.com/mattn/go-runewidth v0.0.10"
    "github.com/mattn/go-runewidth v0.0.10/go.mod"
    "github.com/mattn/go-runewidth v0.0.9"
    "github.com/mattn/go-runewidth v0.0.9/go.mod"
    "git.iglou.eu/Imported/go-wildcard v1.0.1"
    "git.iglou.eu/Imported/go-wildcard v1.0.1/go.mod"
    "github.com/jedib0t/go-pretty/v6 v6.0.5"
    "github.com/jedib0t/go-pretty/v6 v6.0.5/go.mod"
    "github.com/mattn/go-runewidth v0.0.13"
    "github.com/mattn/go-runewidth v0.0.13/go.mod"
    "github.com/muesli/termenv v0.8.1"
    "github.com/muesli/termenv v0.8.1/go.mod"
    "golang.org/x/sys v0.0.0-20210414055047-fe65e336abe0"
    "golang.org/x/sys v0.0.0-20210414055047-fe65e336abe0/go.mod"
    "golang.org/x/term v0.0.0-20210406210042-72f3dc4e9b72"
    "golang.org/x/term v0.0.0-20210406210042-72f3dc4e9b72/go.mod"
    "golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
    "golang.org/x/crypto v0.0.0-20200820211705-5c72a883971a"
    "golang.org/x/crypto v0.0.0-20200820211705-5c72a883971a/go.mod"
    "golang.org/x/sys v0.0.0-20180816055513-1c9583448a9c/go.mod"
    "golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
    "golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
    "golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
    "golang.org/x/sys v0.0.0-20200918174421-af09f7315aff"
    "golang.org/x/sys v0.0.0-20200918174421-af09f7315aff/go.mod"
    "github.com/pkg/profile v1.2.1"
    "github.com/pkg/profile v1.2.1/go.mod"
    "github.com/pmezard/go-difflib v1.0.0"
    "github.com/pmezard/go-difflib v1.0.0/go.mod"
    "github.com/stretchr/testify v1.2.2"
    "github.com/stretchr/testify v1.2.2/go.mod"
    "github.com/rivo/uniseg v0.1.0"
    "github.com/rivo/uniseg v0.1.0/go.mod"
    "github.com/lucasb-eyer/go-colorful v1.2.0"
    "github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
    "github.com/mattn/go-isatty v0.0.12"
    "github.com/mattn/go-isatty v0.0.12/go.mod"
    "golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3"
    "golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
    "golang.org/x/text v0.3.0"
    "golang.org/x/text v0.3.0/go.mod"
)

go-module_set_globals

DESCRIPTION="Disk Usage/Free Utility - a better 'df' alternative"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+="${EGO_SUM_SRC_URI}"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="pie"

src_compile() {
    # -buildmode=pie forces external linking mode, even CGO_ENABLED=0
    # https://github.com/golang/go/issues/18968
    use pie && local build_pie="-buildmode=pie"

    local build_flags="$( echo ${EGO_BUILD_FLAGS} ) $( echo ${build_pie} )"

    set -- env \
        GOCACHE="${T}/go-cache" \
        CGO_ENABLED=0 \
        go build -mod=readonly -v -work -x ${build_flags} -o "bin/${PN}" ${EGO_PN}
    echo "$@"
    "$@" || die
}

src_install() {
    dobin bin/*
}
