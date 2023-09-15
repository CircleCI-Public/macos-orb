#!/usr/bin/env bash

printf '\nCreating the user account...'
sudo /usr/sbin/sysadminctl -addUser vncuser -fullName "${ORB_VAL_USERNAME}" -password "${!ORB_ENV_PASSWORD}" -admin

MAC_VER=$(sw_vers -productVersion | cut -d. -f1)

printf '\nGranting automation permissions...'
EPOCH=$(($(date +'%s * 1000 + %-N / 1000000')))
TCC="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"/usr/sbin/sshd\",1,2,3,1,\"UNUSED\",0,$EPOCH);"
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$TCC"
sudo sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "$TCC"

if (( "$MAC_VER" >= 13 )); then
  printf '\nOpening System Settings...'
  # Attempt to open the pref pane twice as sometimes it will default to the update pane
  open x-apple.systempreferences:com.apple.Sharing-Settings.extension
  sleep 5
  open x-apple.systempreferences:com.apple.Sharing-Settings.extension

  printf '\nRunning AppleScript. Please wait ~20 seconds...'
  osascript -e "tell application \"System Events\"
    tell process \"System Settings\"
      delay 5
      click button 1 of group 1 of scroll area 1 of group 1 of group 1 of group 2 of splitter group 1 of group 1 of window \"Sharing\"
      delay 5
    end tell
  end tell"

  sudo killall "System Settings"
else
  printf '\nOpening System Preferences...'
  open -b com.apple.systempreferences /System/Library/PreferencePanes/SharingPref.prefPane

  printf '\nRunning AppleScript. Please wait ~20 seconds...'
  osascript -e "tell application \"System Events\"
    tell process \"System Preferences\"
      delay 5
      click checkbox 1 of row 7 of table 1 of scroll area 1 of group 1 of window \"Sharing\"
      delay 5
    end tell
  end tell"

  sudo killall "System Preferences"
fi

printf '\nDone!...'
