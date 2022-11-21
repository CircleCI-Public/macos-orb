#!/usr/bin/env bash
MAC_VER=$(sw_vers -productVersion | cut -d. -f1)
if (( "$MAC_VER" >= 12 )); then
  sudo strings /System/Library/PrivateFrameworks/TCC.framework/Support/tccd | grep "^kTCCService[A-Z a-z]"
else
  sudo strings /System/Library/PrivateFrameworks/TCC.framework/Versions/Current/Resources/tccd | grep "^kTCCService[A-Z a-z]"
fi
