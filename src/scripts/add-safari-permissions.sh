#!/usr/bin/env bash

if csrutil status | grep -q 'disabled'; then
    epochdate=$(($(date +'%s * 1000 + %-N / 1000000')))
    macos_major_version=$(sw_vers -productVersion | awk -F. '{ print $1 }')
    if [[ $macos_major_version -le 10 ]]; then
      defaults write com.apple.Safari AllowRemoteAutomation 1
    else
      tcc_service_accessibility="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier_type,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"/usr/sbin/sshd\",1,2,4,1,0,\"UNUSED\",0,$epochdate);"
      tcc_service_events="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier_type,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAppleEvents\",\"/usr/sbin/sshd\",1,2,4,1,0,\"com.apple.systemevents\",0,$epochdate);"
      sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_accessibility"
      sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_accessibility"
      sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_events"
      sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_events"

      # enable remote browser automation tool
      sudo safaridriver --enable

      mkdir -p "$HOME/Library/WebDriver"
      plist="$HOME/Library/WebDriver/com.apple.Safari.plist"
      /usr/libexec/PlistBuddy -c 'delete AllowRemoteAutomation' "$plist" > /dev/null 2>&1 || true
      /usr/libexec/PlistBuddy -c 'add AllowRemoteAutomation bool true' "$plist" > /dev/null 2>&1
    fi
else
    echo "Unable to add permissions! System Integrity Protection is enabled on this image"
    echo "Please choose an image with SIP disabled. Documentation: https://circleci.com/docs/2.0/testing-macos"
    exit 1
fi
