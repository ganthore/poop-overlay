# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Taken open-overlay 2015 by Alex

EAPI="5"

inherit eutils

# MY_PV="14.0.0.0"
# Lightworks-Beta-91065-14.0.0.0.deb

DESCRIPTION="Lightworks is the fastest, most accessible and focused NLE in the industry"
HOMEPAGE="http://www.lwks.com/"
# SRC_URI="http://downloads.lwks.com/Lightworks-Beta-91065-14.0.0.0.deb"
SRC_URI="http://downloads.lwks.com/Lightworks-Beta-91065-${PV}.deb"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT=""
IUSE=""

RDEPEND="
	dev-libs/glib:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/libffi
	sys-apps/dbus
	virtual/udev
	x11-libs/pango
	x11-libs/gdk-pixbuf
	x11-libs/cairo
	x11-libs/pixman
	x11-libs/gtk+:3
	dev-qt/qtgui:4
	dev-qt/qtcore:4
	virtual/jpeg:0
	gnome-extra/libgsf
	media-libs/libpng:0
	media-libs/tiff:3
	>=media-libs/freetype-2
	media-libs/fontconfig
	media-libs/glu
	media-libs/mesa
	media-libs/portaudio
	>=media-gfx/nvidia-cg-toolkit-3.1.0013-r2
	x11-libs/libxcb
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXrender
	x11-libs/libXfixes
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libdrm
	app-accessibility/at-spi2-core
"

DEPEND="${RDEPEND}
	!app-arch/deb2targz
	app-arch/unzip
	x11-apps/mkfontdir"

S="${WORKDIR}"

#Lightworks-Beta-91065-${MY_PV}.deb

pkg_nofetch() {
	einfo "Please download"
	einfo "  - Lightworks-Beta-91065-${PV}.deb"
	einfo "from ${HOMEPAGE} and place it in ${DISTDIR}"
}

pkg_setup() {
	:;
}

src_unpack() {
	unpack ${A}
	unpack ./data.tar.xz
	#unpack ./control.tar.xz
}

src_prepare() {
	# Generate a machine number (if there isn't one already)
	if [ ! -f /usr/share/${PN}/machine.num ];
	then
		cat > usr/share/${PN}/machine.num << EOF
		$((`cat /dev/urandom|od -N1 -An -i` % 2500))
EOF
	else
		cat /usr/share/${PN}/machine.num > usr/share/${PN}/machine.num
	fi
}

src_compile() {
	:;
}

src_install() {
	insinto /usr/lib64/${PN}
	doins -r usr/lib/${PN}/* || die "doins lib failed"

	exeinto /usr/lib64/${PN}
	doexe usr/lib/${PN}/spawn || die "doins lib-exe failed"
	doexe usr/lib/${PN}/ntcardvt || die "doins lib-exe failed"

	dosym /usr/lib64/${PN}/spawn /usr/bin/${PN} || die "doins bin failed"

	fperms a+rw "usr/share/lightworks/Preferences"
	fperms a+rw "usr/share/lightworks/Audio Mixes"

	insinto /usr/share/${PN}
	doins -r usr/share/${PN}/* || die "doins share failed"

	insinto /usr/share/applications
	doins usr/share/applications/* || die "doins desktop application failed"

	insinto /usr/share/fonts
	doins -r usr/share/fonts/* || die "doins fonts failed"
	mkfontdir "${D}/usr/share/fonts/truetype"

	dodoc usr/share/doc/${PN}/*
}
pkg_postinst() {
	echo
	elog "Finaly I had some time to play around. First of all yes libjpeg-turbo is the new default jpeg library in gentoo for quite some time now."
	elog "The lazy way:"
	elog "grap the ftp.uni-erlangen.de/debian/pool/main/libj/libjpeg8/libjpeg8_8b-1_amd64.deb"
	elog "extract the libjpeg.so.8.0.2"
	elog "run: LD_PRELOAD=/some/path/libjpeg.so.8.0.2 lightworks"
	elog "Thanks open-overlay 2015 by Alex"
	elog "Please report bugs in ebuilds for me on email:a.xarlanov29@gmail.com"
	echo
}
