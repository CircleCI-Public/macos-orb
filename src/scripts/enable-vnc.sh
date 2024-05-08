#!/usr/bin/env bash

printf '\nCreating the user account...'
sudo /usr/sbin/sysadminctl -addUser vncuser -fullName "${ORB_VAL_USERNAME}" -password "${!ORB_ENV_PASSWORD}" -admin

printf '\nGranting automation permissions...'
EPOCH=$(($(date +'%s * 1000 + %-N / 1000000')))
TCC="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"/usr/sbin/sshd\",1,2,3,1,\"UNUSED\",0,$EPOCH);"
sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$TCC"
sudo sqlite3 "$HOME/Library/Application Support/com.apple.TCC/TCC.db" "$TCC"

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart \
  -activate -configure -access -on \
  -clientopts -setvnclegacy -vnclegacy yes \
  -restart -agent -privs -all

printf '\nDone! To Access VNC (SSH jobs only), run the following command to forward the VNC port:'
IP=$(ifconfig en0 | awk '/inet / {print $2}')
printf '\nssh -p 54782 %s -L5901:localhost:5900 -N' "$IP"
printf '\nThen point your VNC client to localhost:5901 and use username %s and' "$MAC_ORB_VNC_USERNAME"
printf '\nthe password set in your MAC_ORB_VNC_PASSWORD project environment variable'
printf '\n\nTo view the screen for the distiller user, we recommend using the Screen Sharing app'
printf '\nincluded with macOS and choose the "Share The Display" option when logging in to VNC'
