#!/bin/bash

CUR_PATH=$(
  cd $(dirname "$0");
  pwd
)
ROOT_PATH=$(
  cd "${CUR_PATH}/../";
  pwd
)

function export_entitlements() {
    codesign -d --entitlements - --xml "$1" 2>/dev/null | plutil -convert xml1 -o - - > "$2"
    /usr/libexec/PlistBuddy -c "Delete :com.apple.security.application-groups" "$2" 2>/dev/null
    /usr/libexec/PlistBuddy -c "Delete :com.apple.developer.team-identifier" "$2" 2>/dev/null
    /usr/libexec/PlistBuddy -c "Delete :keychain-access-groups" "$2" 2>/dev/null
    sed -i "" "s/4C6364ACXT\.//g" "$2"
}

function export_application_entitlements() {
  oldIFS=$IFS
  IFS=$'\n'
  for name in $(ls "/Volumes/Parallels Toolbox/Install Parallels Toolbox.app/Contents/Applications/")
  do
      export_entitlements "/Volumes/Parallels Toolbox/Install Parallels Toolbox.app/Contents/Applications/${name}" "${ROOT_PATH}/entitlements/${name}.entitlements"
  done
  IFS=oldIFS
}

mkdir -p "${ROOT_PATH}/entitlements"

export_application_entitlements
export_entitlements "/Volumes/Parallels Toolbox/Install Parallels Toolbox.app/Contents/Library/Install/ToolboxInstaller" "${ROOT_PATH}/entitlements/ToolboxInstaller.entitlements"
export_entitlements "/Volumes/Parallels Toolbox/Install Parallels Toolbox.app" "${ROOT_PATH}/entitlements/Install Parallels Toolbox.app.entitlements"
