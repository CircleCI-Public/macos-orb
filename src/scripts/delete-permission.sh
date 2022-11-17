#!/usr/bin/env bash
if csrutil status | grep -q 'disabled'; then
    sudo sqlite3 "/Library/Application Support/com.apple.TCC/TCC.db" "delete from access where (client = \"<< parameters.bundle-id >>\" and service = \"<< parameters.permission-type >>\")"
    sudo sqlite3 "/Users/$USER/Library/Application Support/com.apple.TCC/TCC.db" "delete from access where (client = \"<< parameters.bundle-id >>\" and service = \"<< parameters.permission-type >>\")"
else
    echo "Unable to add permissions! System Integrity Protection is enabled on this image"
    echo "Please choose an image with SIP disabled. Documentation: https://circleci.com/docs/2.0/testing-macos"
    exit 1
fi
