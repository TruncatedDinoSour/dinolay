# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# inherit multilib
inherit cmake git-r3

# from mva
#inherit multibuild

DESCRIPTION="Cross-platform library for building Telegram clients"
HOMEPAGE="https://core.telegram.org/tdlib"
EGIT_REPO_URI="https://github.com/tdlib/td.git"
EGIT_COMMIT_TYPE="single+tags"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+clang cli debug doc gcc low-ram lto java javascript"

REQUIRED_USE="
    gcc? ( !clang )
    !gcc? ( clang )
    java? ( !lto )
"

# mva dosn't have it but it is probably achieved by his src_prepare
# S="${WORKDIR}/td-${PV}"

# From mva
# BDEPEND="
#   || (
#       >=sys-devel/clang-3.4:=
#       >=sys-devel/gcc-4.9:=
#   )
#   dev-util/gperf
#   virtual/jdk:=
# "

BDEPEND="gcc? ( >=sys-devel/gcc-4.9:= )
    >=dev-util/cmake-3.0.2
    dev-util/gperf
    clang? ( >=sys-devel/clang-3.4:= )
    low-ram? ( dev-lang/php[cli,ctype] )
    doc? (
        dev-lang/php
        app-doc/doxygen
        )
    java? ( virtual/jdk:= )"

RDEPEND="dev-libs/openssl:0=
    sys-libs/zlib"

DOCS=( README.md )

# from mva
src_prepare() {
    sed -r \
        -e '/install\(TARGETS/,/  INCLUDES/{s@(LIBRARY DESTINATION).*@\1 ${CMAKE_INSTALL_LIBDIR}@;s@(ARCHIVE DESTINATION).*@\1 ${CMAKE_INSTALL_LIBDIR}@;s@(RUNTIME DESTINATION).*@\1 ${CMAKE_INSTALL_BINDIR}@}' \
        -i CMakeLists.txt
    cmake_src_prepare
}

src_configure(){
    local mycmakeargs=(
        -DCMAKE_BUILD_TYPE=$(usex debug Debug Release)
        -DCMAKE_INSTALL_PREFIX=/usr
        -DTD_ENABLE_LTO=$(usex lto ON OFF)
        -DTD_ENABLE_JNI=$(usex java ON OFF)
        # According to TDLib build instructions, DOTNET=ON is only needed
        # for using tdlib from C# under Windows through C++/CLI
        -DTD_ENABLE_DOTNET=OFF
    )

    cmake_src_configure

    if use low-ram; then
        cmake --build "${BUILD_DIR}" --target prepare_cross_compiling
        php SplitSource.php
        # todo: we need to die on errors here but I don't know how
    fi

}

src_compile() {

    cmake_src_compile

    # from pg_overlay
    if use doc ; then
        doxygen Doxyfile || die "Could not build docs with doxygen"
    fi
    # completes without errors but I don't know if it's sensible
}

src_install() {

    # was suggested by upstream but seems redundant
    # use low-ram && php SplitSource.php --undo

    cmake_src_install

    use cli && dobin "${BUILD_DIR}"/tg_cli
    # can't we just skip it during build?

    # from pg_overlay
    use doc && local HTML_DOCS=( docs/html/. )
    einstalldocs

}
