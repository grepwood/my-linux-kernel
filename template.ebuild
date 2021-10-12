# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER=""

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental otheros++"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
PS3_COMMIT_ID=""
PS3_URI="https://github.com/CheezeCake/ps3linux-patches/archive/${PS3_COMMIT_ID}.tar.gz"
SRC_URI="${KERNEL_URI}
	${ARCH_URI}
	${GENPATCHES_URI}
	${PS3_URI} -> ps3linux-${PV}.tar.gz
"

src_unpack() {
	set -x
	if use otheros++; then
		UNIPATCH_LIST+=" ${DISTDIR}/ps3linux-${PV}.tar.gz"
	fi
	kernel-2_src_unpack
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
