#!/usr/bin/env bash

DEVICE_UDID=$(eval "echo $ORB_EVAL_DEVICE_UDID")
xcrun simctl bootstatus "${DEVICE_UDID}"
