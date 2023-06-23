#!/usr/bin/env bash

DEVICE_UDID="${ORB_EVAL_DEVICE_UDID}"
xcrun simctl bootstatus "${DEVICE_UDID}"
