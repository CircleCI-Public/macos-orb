#!/usr/bin/env bash

macos_major_version=$(sw_vers -productVersion | awk -F. '{ print $1 }')

if [[ $macos_major_version -le 10 ]]; then
    select_query="select client,service,allowed from access"
else
    select_query="select client,service,auth_value from access"
fi

sudo sqlite3 -column -header "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$select_query"