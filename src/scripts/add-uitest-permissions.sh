#!/usr/bin/env bash
if csrutil status | grep -q 'disabled'; then
    epochdate=$(($(date +'%s * 1000 + %-N / 1000000')))
    macos_major_version=$(sw_vers -productVersion | awk -F. '{ print $1 }')
    if [[ $macos_major_version -le 10 ]]; then
        tcc_service_accessibility="replace into access (service,client,client_type,allowed,prompt_count,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"com.apple.dt.Xcode-Helper\",0,1,1,\"UNUSED\",0,$epochdate);"
        tcc_service_developer_tool="replace into access (service,client,client_type,allowed,prompt_count,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceDeveloperTool\",\"com.apple.Terminal\",0,1,1,\"UNUSED\",0,$epochdate);"
    else
        tcc_service_accessibility="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceAccessibility\",\"com.apple.dt.Xcode-Helper\",0,2,1,1,\"UNUSED\",0,$epochdate);"
        tcc_service_developer_tool="replace into access (service,client,client_type,auth_value,auth_reason,auth_version,indirect_object_identifier,flags,last_modified) values (\"kTCCServiceDeveloperTool\",\"com.apple.Terminal\",0,2,1,1,\"UNUSED\",0,$epochdate);"
    fi
    sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_accessibility"
    sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_accessibility"
    sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_developer_tool"
    sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "$tcc_service_developer_tool"
else
    echo "Unable to add permissions! System Integrity Protection is enabled on this image"
    echo "Please choose an image with SIP disabled. Documentation: https://circleci.com/docs/2.0/testing-macos"
    exit 1
fi
