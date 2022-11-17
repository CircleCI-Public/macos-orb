#!/usr/bin/env bash

printf '\nCreating the user account...'
sudo /usr/sbin/sysadminctl -addUser vncuser -fullName "${ORB_VAL_USERNAME}" -password "${!ORB_ENV_PASSWORD}" -admin

MAC_VER=$(sw_vers -productVersion | cut -d. -f1)
if (( "$MAC_VER" >= 12 )); then
  printf '\nmacOS12+ requires VNC to be enabled via System Preferences...'
  printf '\nGranting automation permissions...'
  EPOCH=$(($(date +'%s * 1000 + %-N / 1000000')))
  TCC="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"/usr/sbin/sshd\",1,2,3,1,\"UNUSED\",0,$EPOCH);"
  sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$TCC"
  sudo sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "$TCC"

  printf '\nOpening System Preferences...'
  open -b com.apple.systempreferences /System/Library/PreferencePanes/SharingPref.prefPane

  printf '\nRunning AppleScript. Please wait ~20 seconds...'
  osascript -e "tell application \"System Events\"
    tell process \"System Preferences\"
      delay 5
      click checkbox 1 of row 7 of table 1 of scroll area 1 of group 1 of window \"Sharing\"
      delay 5
      click checkbox 1 of row 2 of table 1 of scroll area 1 of group 1 of window 1
      delay 5
      click radio button \"All users\" of radio group 1 of group 1 of window \"Sharing\"
    end tell
  end tell

  repeat until application \"System Preferences\" is not running
    tell application \"System Preferences\"
      quit
      delay 2
    end tell
  end repeat"
  printf '\nDone!...'
fi
