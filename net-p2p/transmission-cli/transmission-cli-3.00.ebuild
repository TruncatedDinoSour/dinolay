EAPI=7

DESCRIPTION="A Fast, Easy and Free BitTorrent client - command line (CLI) version"
HOMEPAGE="http://www.transmissionbt.com/"
MY_PN="transmission"
MY_P="${MY_PN}-${PV}"
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"

SRC_URI="https://github.com/transmission/transmission-releases/raw/master/${MY_P}.tar.xz"

KEYWORDS="~amd64 -arm -mips -ppc -ppc64 -x86 ~amd64-linux"
IUSE=""

RDEPEND="
	dev-libs/libevent:=
	net-misc/curl[ssl]
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}
	dev-libs/glib
	dev-util/intltool
	sys-devel/gettext
	virtual/os-headers
	virtual/pkgconfig
"

SLOT=0

S="${WORKDIR}/${MY_P}"

src_configure() {
	econfargs+=(
		--enable-cli
		--disable-daemon
		--without-gtk
		--without-systemd-daemon
	)
	econf "${econfargs[@]}"
}

src_install() {
	dobin cli/transmission-cli
	doman cli/transmission-cli.1
}

