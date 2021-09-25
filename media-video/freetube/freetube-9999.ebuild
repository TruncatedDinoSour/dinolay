# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeTubeApp/FreeTube.git"
	S="${WORKDIR}/${P}"
	KEYWORDS="~amd64"
else
	SRC_URI="https://github.com/FreeTubeApp/FreeTube/archive/v${PV/_beta/-beta}.tar.gz -> ${P}.tar.gz"
	RESTRICT="primaryuri"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/FreeTube-${PV/_beta/-beta}"
fi

inherit desktop

DESCRIPTION="An Open Source YouTube app for privacy"
HOMEPAGE="https://github.com/FreeTubeApp/FreeTube"

LICENSE="GPL-3"
SLOT="0"
IUSE="vanilla"

DEPEND="
net-libs/nodejs[npm]
sys-apps/yarn
"
RDEPEND="
net-libs/nodejs
virtual/electron:3.0
"

src_unpack() {
	default
	type git-r3_src_unpack > /dev/null 2>&1 && git-r3_src_unpack

	cd "${S}" || die
	yarn install --production --no-bin-links --no-lockfile || die
	rm -rf node_modules || die
	yarn || die
	rm -rf node_modules || die
	npm install --verbose --no-optional --no-shrinkwrap || die
	mv node_modules "${T}"/node_modules-dev || die
}

src_prepare() {
	sed -i '/^.*"deb",/d' package.json
	sed -i '/^.*"rpm",/d' package.json
	sed -i '/^.*"electron-forge-maker-appimage",/d' package.json
	default
}

src_compile() {
	# force yarn to work offline
	mkdir -p "${T}/.bin"
	cat > "${T}/.bin/yarn" << EOF
#!/bin/sh
exec /usr/bin/yarn $@ --offline
EOF
chmod +x "${T}/.bin/yarn"
export PATH="${T}/.bin:$PATH"
env NODE_PATH="$PWD/node_modules:$T/node_modules-dev" "${T}"/node_modules-dev/.bin/electron-forge make --target zip
}

src_install() {
	# The binaries called FreeTube instead of freetube to be
	# consistent with the debs upstream ships
	cp "${FILESDIR}/${PN}.js" "${T}/FreeTube"

	sed -i 's|{{ELECTRON_VERSION}}|electron-3.0|g' "${T}/FreeTube"

	dobin "${T}/FreeTube"

	# Remove stuff we do not need
	#! use vanilla && find node_modules \
	#	-name "*.a" -exec rm '{}' \; \
	#	-or -name "*.bat" -exec rm '{}' \; \
	#	-or -name "*.node" -exec chmod a-x '{}' \; \
	#	-or -name "benchmark" -prune -exec rm -r '{}' \; \
	#	-or -name "doc" -prune -exec rm -r '{}' \; \
	#	-or -name "html" -prune -exec rm -r '{}' \; \
	#	-or -name "man" -prune -exec rm -r '{}' \; \
	#	-or -path "*/less/gradle" -prune -exec rm -r '{}' \; \
	#	-or -path "*/task-lists/src" -prune -exec rm -r '{}' \;

	dodir /usr/lib/FreeTube
	cp -a out/FreeTube-linux-x64/resources/app/* "${D}usr/lib/FreeTube"

	newicon src/icons/iconColor.png "FreeTube.png"
	domenu "${FILESDIR}/FreeTube.desktop"
}

