#!/usr/bin/env bash
if [ $(uname -m) = "arm64" ]; then
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
else
    echo "Rosetta 2 can only be installed on Apple Silicon!"
    exit 1
fi
