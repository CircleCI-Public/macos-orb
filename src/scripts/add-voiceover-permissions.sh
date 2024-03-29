#!/usr/bin/env bash

if csrutil status | grep -q 'disabled'; then
    defaults write com.apple.VoiceOverTraining doNotShowSplashScreen -bool true
    defaults write com.apple.VoiceOver4/default SCREnableAppleScript -bool true
    sudo bash -c 'echo -n "a" > /private/var/db/Accessibility/.VoiceOverAppleScriptEnabled'
else
    echo "Unable to add permissions! System Integrity Protection is enabled on this image"
    echo "Please choose an image with SIP disabled. Documentation: https://circleci.com/docs/2.0/testing-macos"
    exit 1
fi
