## TL;DR 
Solution was to pass `CODE_SIGN_STYLE=Manual` alongside with `DEVELOPMENT_TEAM=...` and `CODE_SIGN_IDENTITY=...`.
For more info see [this thread on Swift Forums](https://forums.swift.org/t/xcode-14-beta-code-signing-issues-when-spm-targets-include-resources/59685).

## Overview

A sample project to demonstrate differences in signing between Xcode 13 and Xcode 14 beta 6. Especially when a setup includes an app target that depends on an SPM library which in turn depends on another SPM library with resources. And codesigning settings are overridden via `xcodebuild` arguments.

### Setup

* App target
  * SPM library 1
    * SPM library 2 with resources

### Preprequisites

Open `SPMBundleSign.xcworkspace` and update Signing settings for SPMBundleSign target to match your team and provisioning profile.

## Steps to reproduce

### Xcode 13.4
* Select Xcode 13.4 via `xcode-select`
* Run 
```
./archive.sh CODE_SIGN_IDENTITY="Apple Distribution"
```
* Archive should succeed

```
<...>
Touch ~/Library/Developer/Xcode/DerivedData/SPMBundleSign-haxtvhvzilukzufoivtdboknlobj/Build/Intermediates.noindex/ArchiveIntermediates/SPMBundleSign/InstallationBuildProductsLocation/Applications/SPMBundleSign.app (in target 'SPMBundleSign' from project 'SPMBundleSign')
    cd ~/dev/oss/spm-bundle-sign
    /usr/bin/touch -c ~/Library/Developer/Xcode/DerivedData/SPMBundleSign-haxtvhvzilukzufoivtdboknlobj/Build/Intermediates.noindex/ArchiveIntermediates/SPMBundleSign/InstallationBuildProductsLocation/Applications/SPMBundleSign.app

** ARCHIVE SUCCEEDED **
```

### Xcode 14 beta 6
* Select Xcode 14 beta 6 via `xcode-select`
* Run 
```
./archive.sh CODE_SIGN_IDENTITY="Apple Distribution"
```
* Archive failed #1

```
note: Building targets in dependency order
~/dev/oss/spm-bundle-sign/Package.swift: error: Signing for "spm-bundle-sign-package_TargetWithResources" requires a development team. Select a development team in the Signing & Capabilities editor. (in target 'spm-bundle-sign-package_TargetWithResources' from project 'spm-bundle-sign-package')
** ARCHIVE FAILED **
```

* `"spm-bundle-sign-package_TargetWithResources" requires a development team. Select a development team in the Signing & Capabilities editor.`
  * AFAICS, for "spm-bundle-sign-package_TargetWithResources" there's no access to "Signing & Capabilities editor" since it's an SPM target, but we can pass our development team straight to `xcodebuild` via the script, right?
* Run archiving script with development team 
```
./archive.sh CODE_SIGN_IDENTITY="Apple Distribution" DEVELOPMENT_TEAM="7V2Y6HDP66"
```

* Archive failed #2

```
note: Building targets in dependency order
~/dev/oss/spm-bundle-sign/Package.swift: error: spm-bundle-sign-package_TargetWithResources has conflicting provisioning settings. spm-bundle-sign-package_TargetWithResources is automatically signed for development, but a conflicting code signing identity Apple Distribution has been manually specified. Set the code signing identity value to "Apple Development" in the build settings editor, or switch to manual signing in the Signing & Capabilities editor. (in target 'spm-bundle-sign-package_TargetWithResources' from project 'spm-bundle-sign-package')
~/dev/oss/spm-bundle-sign/SPMBundleSign/Dependencies/Package.swift: error: DependenciesUmbrella has conflicting provisioning settings. DependenciesUmbrella is automatically signed for development, but a conflicting code signing identity Apple Distribution has been manually specified. Set the code signing identity value to "Apple Development" in the build settings editor, or switch to manual signing in the Signing & Capabilities editor. (in target 'DependenciesUmbrella' from project 'Dependencies')
** ARCHIVE FAILED **
```
* `spm-bundle-sign-package_TargetWithResources has conflicting provisioning settings`. 
  * Solution here is to add `CODE_SIGN_STYLE=Manual`
```
./archive.sh CODE_SIGN_IDENTITY="Apple Distribution" DEVELOPMENT_TEAM="7V2Y6HDP66" CODE_SIGN_STYLE="Manual"
```

* Archive succeeded

```
** ARCHIVE SUCCEEDED **
```