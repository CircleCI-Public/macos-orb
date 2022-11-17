#!/usr/bin/env bash
if csrutil status | grep -q 'disabled'; then
    sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "delete from access where (client = \"${ORB_VAL_BUNDLE_ID}\" and service = \"${ORB_VAL_PERMISSION_TYPE}\")"
    sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "delete from access where (client = \"${ORB_VAL_BUNDLE_ID}\" and service = \"${ORB_VAL_PERMISSION_TYPE}\")"
else
    echo "Unable to add permissions! System Integrity Protection is enabled on this image"
    echo "Please choose an image with SIP disabled. Documentation: https://circleci.com/docs/2.0/testing-macos"
    exit 1
fi
