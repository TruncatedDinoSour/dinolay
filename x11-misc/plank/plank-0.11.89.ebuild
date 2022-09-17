# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.34"

inherit autotools gnome2-utils vala xdg

DESCRIPTION="Elegant, simple, clean dock"
HOMEPAGE="https://github.com/ricotz/plank"

if [[ ${PV} == 9999 ]]; then
    inherit git-r3
    EGIT_REPO_URI="${HOMEPAGE}.git"
    KEYWORDS=""
else
    SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
RESTRICT="mirror"
IUSE="apport barriers benchmark dbus debug doc nls"

RDEPEND="dev-libs/atk
dev-libs/glib:2
dev-libs/libdbusmenu[gtk,gtk3]
dev-libs/libgee
gnome-base/gnome-menus
sys-libs/glibc
x11-libs/bamf
x11-libs/cairo
x11-libs/gdk-pixbuf
x11-libs/gtk+:3
x11-libs/libX11
x11-libs/libXfixes
x11-libs/libXi
x11-libs/libwnck
x11-libs/pango"

DEPEND="${RDEPEND}
$(vala_depend)
doc? ( dev-lang/vala[valadoc] )"

src_prepare() {
    # dev-lang/vala[valadoc] does not create a symlink /usr/bin/valadoc
    sed -i "308s/valadoc/valadoc-$(vala_best_api_version)/" configure.ac || die "sed failed"
    eapply_user
    eautoreconf
    vala_src_prepare
}

src_configure() {
    econf \
        $(use_enable apport) \
        $(use_enable barriers) \
        $(use_enable benchmark) \
        $(use_enable dbus dbusmenu) \
        $(use_enable debug) \
        $(use_enable doc docs) \
        $(use_enable nls)
}

pkg_postinst() {
    gnome2_schemas_update
    xdg_pkg_postinst
}

pkg_postrm() {
    gnome2_schemas_update
    xdg_pkg_postrm
}
