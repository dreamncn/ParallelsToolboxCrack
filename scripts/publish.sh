#!/bin/bash

CUR_PATH=$(
  cd $(dirname "$0");
  pwd
)
ROOT_PATH=$(
  cd "${CUR_PATH}/../";
  pwd
)
TEMP_PATH="${ROOT_PATH}/tmp"
PUBLISH_PATH="${ROOT_PATH}/publish"

PTFM_VERSION="6.0.1-4541"

PTFM_SHA256SUM="0229e670bad744a02c5349ab1bf31aa7ba8dff52840b9d410ce599b350f61aa6"

PTFM_DMG_DOWNLOAD_URL="https://download.parallels.com/toolbox/v6/${PTFM_VERSION}/ParallelsToolbox-${PTFM_VERSION}.dmg"

PTFM_DMG_FILE="${TEMP_PATH}/download/ParallelsToolbox-${PTFM_VERSION}.dmg"

PTFM_PUBLISH_FILE="${PUBLISH_PATH}/ParallelsToolbox-${PTFM_VERSION}_Crack.dmg"

CODESIGN_CERT=-

if [ -n "$(security find-identity -v -p codesigning | grep 73B34EBEE504D5CEE35B113A22CEBFD381A21033)" ]; then
	CODESIGN_CERT=73B34EBEE504D5CEE35B113A22CEBFD381A21033
fi

PTFM_TMP_DIR="${TEMP_PATH}/ptfm_files"

function sign_cmd() {
	NAME=$(basename $1)
	if [ -f "${ROOT_PATH}/entitlements/${NAME}.entitlements" ]; then
		codesign -f -s "${CODESIGN_CERT}" --timestamp=none --all-architectures --deep \
		--entitlements "${ROOT_PATH}/entitlements/${NAME}.entitlements" \
		"$1"
	else
		codesign -f -s "${CODESIGN_CERT}" --timestamp=none --all-architectures --deep "$1"
	fi
}

function ensure_download_ptfm_dmg() {
	if [ ! -f "${PTFM_DMG_FILE}" ]; then
		echo "[*] Download ${PTFM_DMG_DOWNLOAD_URL}"
		mkdir -p $(dirname "${PTFM_DMG_FILE}")
		curl -L --progress-bar -o "${PTFM_DMG_FILE}" "${PTFM_DMG_DOWNLOAD_URL}"
	fi
	if [ -f "${PTFM_DMG_FILE}" ]; then
		echo "[*] Check hash for \"${PTFM_DMG_FILE}\""
		FILE_HASH=$(shasum -a 256 -b "${PTFM_DMG_FILE}" | awk '{print $1}')
		if [ ${FILE_HASH} != ${PTFM_SHA256SUM} ]; then
			echo "[-] ${FILE_HASH} != ${PTFM_SHA256SUM}"
			echo "[*] Delete \"${PTFM_DMG_FILE}\""
			rm -f "${PTFM_DMG_FILE}"
		fi
	fi
}

function copy_ptfm_files() {
	echo "[*] Copy files"
	if [ -d "${PTFM_TMP_DIR}" ]; then
		rm -rf "${PTFM_TMP_DIR}" > /dev/null
	fi
	mkdir -p "${PTFM_TMP_DIR}" > /dev/null

	hdiutil attach -noverify -noautofsck -noautoopen "${PTFM_DMG_FILE}"
	cp -R -X "/Volumes/Parallels Toolbox/Install Parallels Toolbox.app" "${PTFM_TMP_DIR}/" > /dev/null
	hdiutil detach "/Volumes/Parallels Toolbox"

	rm -f "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/embedded.provisionprofile" > /dev/null
	chflags -R 0 "${PTFM_TMP_DIR}" > /dev/null
	xattr -cr "${PTFM_TMP_DIR}" > /dev/null
}

function apply_ptfm_crack() {
	echo "[*] Apply patch"

	SRC="${ROOT_PATH}/crack/LicenseServices"
	DST="${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Frameworks/LicenseServices.framework/Versions/A/LicenseServices"

	cp -f "${SRC}" "${DST}" > /dev/null
	chflags -R 0 "${DST}"
	chmod 755 "${DST}"
}

function sign_ptfm_application() {
	oldIFS=$IFS
	IFS=$'\n'
	for name in $(ls "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/")
	do
		if [ -f "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/${name}/Contents/embedded.provisionprofile" ]; then
			rm -f "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/${name}/Contents/embedded.provisionprofile" > /dev/null
		fi
		sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Applications/${name}"
	done
	IFS=oldIFS
}

function sign_ptfm() {
	echo "[*] Sign Parallels Toolbox App"
	sign_ptfm_application
	if [ -f "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/embedded.provisionprofile" ]; then
		rm -f "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/embedded.provisionprofile" > /dev/null
	fi
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app/Contents/Library/Install/ToolboxInstaller"
	sign_cmd "${PTFM_TMP_DIR}/Install Parallels Toolbox.app"
}

function create_ptfm_dmg() {
	echo "[*] Create dmg ${PTFM_PUBLISH_FILE}"
	mkdir -p "${PUBLISH_PATH}"

	if [ -f "${PTFM_PUBLISH_FILE}" ]; then
		rm -f "${PTFM_PUBLISH_FILE}" > /dev/null
	fi

	create-dmg \
		--volname "Parallels Toolbox" \
		--volicon "${ROOT_PATH}/assets/PTFM.VolumeIcon.icns" \
		--background "${ROOT_PATH}/assets/PTFM.background.png" \
		--window-pos 0 0 \
		--window-size 640 415 \
		--icon-size 256 \
		--icon "Install Parallels Toolbox.app" 450 126 \
		--codesign "${CODESIGN_CERT}" \
		"${PTFM_PUBLISH_FILE}" \
		"${PTFM_TMP_DIR}/"
}

function publish_ptfm_crack_dmg() {
	ensure_download_ptfm_dmg
	copy_ptfm_files
	apply_ptfm_crack
	sign_ptfm
	create_ptfm_dmg
}

publish_ptfm_crack_dmg
