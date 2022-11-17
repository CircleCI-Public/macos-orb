#!/usr/bin/env bash

if ! [ -x "$(command -v rbenv)" ]; then
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
else
    version="$ORB_VAL_RUBY_VERSION"
    needs_fuzzy_matching=$(echo "$ORB_VAL_RUBY_VERSION" | awk -F. '{print NF-1}')

    if [[ $needs_fuzzy_matching == 1 && "$ORB_VAL_RUBY_VERSION" != "system" ]]; then
        version=$(rbenv versions --bare | grep "$test" | head -n 1)
    fi

    rbenv global "$version"
    rbenv rehash
fi