#!/usr/bin/env bash

xcode_major=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f1)
xcode_minor=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f2)
epochdate=$(($(date +'%s * 1000 + %-N / 1000000')))
if [[ xcode_major -ge "12" ]] || [[ xcode_major -eq "11" && xcode_minor -ge "4" ]]; then
tcc_service_accessibility="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier_type,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"/usr/sbin/sshd\",1,2,4,1,0,\"UNUSED\",0,$epochdate);"
tcc_service_events="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier_type,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAppleEvents\",\"/usr/sbin/sshd\",1,2,4,1,0,\"com.apple.systemevents\",0,$epochdate);"
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_accessibility"
sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_accessibility"
sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_events"
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_events"
osascript -e "
    tell application \"System Events\"
    tell application \"/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app\" to activate
    repeat until window 1 of process \"Simulator\" exists
        delay 5
    end repeat
    tell process \"Simulator\"
        set frontmost to true
        click menu item \"Custom Location…\" of menu of menu item \"Location\" of menu \"Features\" of menu bar 1
        tell window 1
        set value of text field 1 to \"$ORB_VAL_LATITUDE\"
        set value of text field 2 to \"$ORB_VAL_LONGITUDE\"
        click button \"OK\"
        end tell
    end tell
    end tell"
else
    echo "This command is only supported from Xcode 11.4 and higher"
    exit 1
fi