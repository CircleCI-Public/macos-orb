#!/usr/bin/env bash

SIMREQ_not_found() {
    # arguments: requested simulator runtime
    echo "ERROR!: Simulator runtime not found"
    echo "Requested: Simulator Runtime: ${1}"
    echo "Available Runtimes:"
    echo "$(echo "${SIMLIST}" | jq -r '.devices | keys[] | select(startswith("com.apple.CoreSimulator.SimRuntime."))')"
    exit 1
}

UDID_not_found() {
    # arguments: requested simulator, device
    SIMS=$(xcrun simctl list devices | tail -n +2)
    echo "ERROR!: UDID not found, check Platform, Version and Device"
    echo "Requested: Simulator: ${1}, Device: ${2}"
    echo "Available:"
    echo "${SIMS}"
    exit 1
}

xcode_major=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f1)
if [[ $xcode_major -ge "12" ]]; then
    ESCAPED_VER=$(echo "$ORB_VAL_VERSION" | tr '.' '-')
    SIMREQ="${ORB_VAL_PLATFORM}-${ESCAPED_VER}"
    SIMLIST=$(xcrun simctl list -j)

    if ! echo "${SIMLIST}" | jq -e ".devices | has(\"com.apple.CoreSimulator.SimRuntime.${SIMREQ}\")" > /dev/null; then
        SIMREQ_not_found "${SIMREQ}"
    fi

    UDID=$(echo "${SIMLIST}" | jq -r ".devices.\"com.apple.CoreSimulator.SimRuntime.${SIMREQ}\"[] | select(.name==\"${ORB_VAL_DEVICE}\").udid")
    if [[ -z "${UDID}" ]]; then
       UDID_not_found "${SIMREQ}" "${ORB_VAL_DEVICE}"
    fi
    echo "export ${ORB_ENV_DEVICE_UDID}=${UDID}" >> "${BASH_ENV}"
    xcrun simctl boot "${UDID}"
else
    xcrun instruments -w "${ORB_VAL_DEVICE} (${ORB_VAL_VERSION}) [" || true
fi
