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
      osascript -e '
        tell application "System Events"
          tell application "Safari" to activate
          delay 15
          tell process "Safari"
            set frontmost to true
            delay 5
            set settingsLabel to "Preferences…"
            if menu item "Settings…" of menu 1 of menu bar item "Safari" of menu bar 1 exists then
              set settingsLabel to "Settings…"
            end if
            click menu item settingsLabel of menu 1 of menu bar item "Safari" of menu bar 1
            delay 5
            click button "Advanced" of toolbar 1 of window 1
            delay 5
            tell checkbox "Show Develop menu in menu bar" of group 1 of group 1 of window 1
              if value is 0 then click it
              delay 5
            end tell
            click button 1 of window 1
            delay 5
            click menu item "Allow Remote Automation" of menu 1 of menu bar item "Develop" of menu bar 1
            delay 5
          end tell
        end tell'
    fi
    sudo safaridriver --enable
else
    echo "Unable to add permissions! System Integrity Protection is enabled on this image"
    echo "Please choose an image with SIP disabled. Documentation: https://circleci.com/docs/2.0/testing-macos"
    exit 1
fi
