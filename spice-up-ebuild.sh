#!/usr/bin/env bash
set -euo pipefail

ebuild_path=$(find /var/db/repos/gentoo/sys-kernel/gentoo-sources -type f -name "gentoo-sources-${branch}.*.ebuild" | sort -n | tail -n1)
K_GENPATCHES_VER=$(grep ^K_GENPATCHES_VER=\".*\"$ ${ebuild_path} | sed 's/^K_GENPATCHES_VER=\"//;s/\"$//')
PATCH_VERSION=$(echo ${ebuild_path} | sed 's/^.*\/gentoo\-sources\-//;s/\.ebuild$//' | awk -F '.' '{ print $3 }')
PS3_COMMIT_ID=$(git ls-remote --heads https://github.com/CheezeCake/ps3linux-patches | awk '{if($2 == "refs/heads/'${branch}'.x") print $1}')

NOT_READY=7
BRANCH_STATUS="true"
if [ "${PS3_COMMIT_ID}" != "" ]; then
	NOT_READY=$((${NOT_READY} - 4))
fi
if [ ${K_GENPATCHES_VER} != "" ]; then
	NOT_READY=$((${NOT_READY} - 2))
fi
if [ ${PATCH_VERSION} != "" ]; then
	NOT_READY=$((${NOT_READY} - 1))
fi
if [ ${NOT_READY} -ne 0 ]; then
	BRANCH_STATUS="false"
fi

echo -e "\t{"
echo -e "\t\t\"version\": \"${branch}.${PATCH_VERSION}\","
echo -e "\t\t\"gentoo_patchset\": \"${K_GENPATCHES_VER}\","
echo -e "\t\t\"ps3_patchset\": \"${PS3_COMMIT_ID}\","
echo -e "\t\t\"possible\": ${BRANCH_STATUS}"
echo -e "\t}"

if [ ${NOT_READY} -eq 0 ]; then
	sed "s/K_GENPATCHES_VER=.*$/K_GENPATCHES_VER=\"${K_GENPATCHES_VER}\"/;s/^PS3_COMMIT_ID=.*$/PS3_COMMIT_ID=\"${PS3_COMMIT_ID}\"/" template.ebuild > my-linux-kernel-${branch}.${PATCH_VERSION}.ebuild
fi
