#!/usr/bin/env bash

if command -v rbenv >/dev/null 2>&1; then
    ruby_ver="$ORB_VAL_RUBY_VERSION"
    if [[ "$ruby_ver" != "system" ]]; then
        ruby_version=$(rbenv versions --bare | grep "$ORB_VAL_RUBY_VERSION" | head -n 1)
        if [[ -z "$ruby_version" ]]; then
            printf "\nNo Rubies installed that match version %s\n" "$ORB_VAL_RUBY_VERSION"
            printf "\nInstalled versions:\n"
            rbenv versions
            exit 1
        fi
    else
        ruby_version="system"
    fi

    rbenv global "$ruby_version"
    rbenv rehash

    printf "\nSet Ruby version succesfully:\n"
    rbenv versions
else
    xcode_major=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f1)
    xcode_minor=$(/usr/bin/xcodebuild -version | awk 'NR==1{print $2}' | cut -d. -f2)
    ruby_ver="$ORB_VAL_RUBY_VERSION"

    if [[ "$ruby_ver" != "system" ]]; then
        ruby_version="ruby-$ORB_VAL_RUBY_VERSION"
    else
        ruby_version="system"
    fi
    
    if [[ $xcode_major -ge "12" ]] || [[ $xcode_major -eq "11" && $xcode_minor -ge "7" ]]; then
        sed -i '' "s/^chruby.*/chruby ${ruby_version}/g" ~/.bash_profile
    elif [[ $xcode_major -eq "11" && $xcode_minor -le "1" ]]; then
        echo "$ruby_version" > ~/.ruby-version
    else
        echo "chruby $ruby_version" >> ~/.bash_profile
    fi
fi
