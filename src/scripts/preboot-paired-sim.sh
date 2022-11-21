#!/usr/bin/env bash

xcode_major=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f1)

if [[ $xcode_major -ge "12" ]]; then
    ESCAPED_IPHONE_VER=$(echo "$ORB_VAL_IPHONE_VERSION" | tr '.' '-')
    ESCAPED_WATCHOS_VER=$(echo "$ORB_VAL_WATCH_VERSION" | tr '.' '-')
    SIMLIST=$(xcrun simctl list -j)
    IPHONE_UDID=$(echo "$SIMLIST" | jq -r ".devices.\"com.apple.CoreSimulator.SimRuntime.iOS-$ESCAPED_IPHONE_VER\"[] | select(.name==\"$ORB_VAL_IPHONE_DEVICE\").udid")
    echo "export $ORB_ENV_IPHONE_UDID=$IPHONE_UDID" >> "$BASH_ENV"
    WATCH_UDID=$(echo "$SIMLIST" | jq -r ".devices.\"com.apple.CoreSimulator.SimRuntime.watchOS-$ESCAPED_WATCHOS_VER\"[] | select(.name==\"$ORB_VAL_WATCH_DEVICE\").udid")
    echo "export $ORB_ENV_WATCH_UDID=$WATCH_UDID" >> "$BASH_ENV"
    PAIR_UDID=$(xcrun simctl pair "$WATCH_UDID $IPHONE_UDID" 2> /dev/null) || true
    echo "export $ORB_ENV_PAIR_UDID=$PAIR_UDID" >> "$BASH_ENV"
    if [ -z "$PAIR_UDID" ]; then
    PAIR_UDID=$(echo "$SIMLIST" | jq -r ".pairs | to_entries[] | select(.value.watch.udid==\"$WATCH_UDID\" and .value.phone.udid==\"$IPHONE_UDID\") | .key")
    fi
    xcrun simctl boot "$PAIR_UDID"
else
    xcrun instruments -w "$ORB_VAL_IPHONE_DEVICE ($ORB_VAL_IPHONE_VERSION) + $ORB_VAL_WATCH_DEVICE ($ORB_VAL_WATCH_VERSION) [" || true
fi
