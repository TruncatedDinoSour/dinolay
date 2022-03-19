# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

EGO_PN="github.com/muesli/${PN}"

EGO_SUM=(
    "github.com/IGLOU-EU/go-wildcard v1.0.3"
    "github.com/IGLOU-EU/go-wildcard v1.0.3/go.mod"
    "github.com/davecgh/go-spew v1.1.0/go.mod"
    "github.com/davecgh/go-spew v1.1.1"
    "github.com/davecgh/go-spew v1.1.1/go.mod"
    "github.com/jedib0t/go-pretty/v6 v6.2.5"
    "github.com/jedib0t/go-pretty/v6 v6.2.5/go.mod"
    "github.com/kr/pretty v0.2.0"
    "github.com/kr/pretty v0.2.0/go.mod"
    "github.com/kr/pty v1.1.1/go.mod"
    "github.com/kr/text v0.1.0"
    "github.com/kr/text v0.1.0/go.mod"
    "github.com/lucasb-eyer/go-colorful v1.2.0"
    "github.com/lucasb-eyer/go-colorful v1.2.0/go.mod"
    "github.com/mattn/go-isatty v0.0.14"
    "github.com/mattn/go-isatty v0.0.14/go.mod"
    "github.com/mattn/go-runewidth v0.0.13"
    "github.com/mattn/go-runewidth v0.0.13/go.mod"
    "github.com/muesli/mango v0.1.0"
    "github.com/muesli/mango v0.1.0/go.mod"
    "github.com/muesli/roff v0.1.0"
    "github.com/muesli/roff v0.1.0/go.mod"
    "github.com/muesli/termenv v0.11.0"
    "github.com/muesli/termenv v0.11.0/go.mod"
    "github.com/pkg/profile v1.6.0/go.mod"
    "github.com/pmezard/go-difflib v1.0.0"
    "github.com/pmezard/go-difflib v1.0.0/go.mod"
    "github.com/rivo/uniseg v0.2.0"
    "github.com/rivo/uniseg v0.2.0/go.mod"
    "github.com/stretchr/objx v0.1.0/go.mod"
    "github.com/stretchr/testify v1.7.0"
    "github.com/stretchr/testify v1.7.0/go.mod"
    "golang.org/x/sys v0.0.0-20180816055513-1c9583448a9c/go.mod"
    "golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
    "golang.org/x/sys v0.0.0-20210630005230-0f9fa26af87c/go.mod"
    "golang.org/x/sys v0.0.0-20220114195835-da31bd327af9"
    "golang.org/x/sys v0.0.0-20220114195835-da31bd327af9/go.mod"
    "golang.org/x/term v0.0.0-20210406210042-72f3dc4e9b72"
    "golang.org/x/term v0.0.0-20210406210042-72f3dc4e9b72/go.mod"
    "gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
    "gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15"
    "gopkg.in/check.v1 v1.0.0-20190902080502-41f04d3bba15/go.mod"
    "gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
    "gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b"
    "gopkg.in/yaml.v3 v3.0.0-20210107192922-496545a6307b/go.mod"
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
