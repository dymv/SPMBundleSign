#!/usr/bin/env zsh

xcodebuild -workspace SPMBundleSign.xcworkspace -scheme SPMBundleSign -configuration Release -destination 'generic/platform=iOS' -archivePath "$HOME/Library/Developer/Xcode/Archives/$(date '+%Y-%m-%d')/SPMBundleSign-$(date '+%H%M%S').xcarchive" clean archive "$@"