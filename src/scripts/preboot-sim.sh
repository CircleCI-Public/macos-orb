#!/usr/bin/env bash

xcode_major=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f1)
if [[ $xcode_major -ge "12" ]]; then
    ESCAPED_VER=$(echo "$ORB_VAL_VERSION" | tr '.' '-')
    SIMLIST=$(xcrun simctl list -j)
    UDID=$(echo "$SIMLIST" | jq -r ".devices.\"com.apple.CoreSimulator.SimRuntime.$ORB_VAL_PLATFORM-$ESCAPED_VER\"[] | select(.name==\"$ORB_VAL_DEVICE\").udid")
    echo "export $ORB_ENV_DEVICE_UDID=$UDID" >> "$BASH_ENV"
    xcrun simctl boot "$UDID"
else
    xcrun instruments -w "$ORB_VAL_DEVICE ($ORB_VAL_VERSION) [" || true
fi
