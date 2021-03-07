Date format: DD/MM/YYYY

## [1.0.0-pre] - iOS update - [00/03/2021]

- **FIX** Unhandled Exception: Bad state: Cannot add new events after calling close
- **FIX** Banner Ad was not working with Virtual Display. (Fixes [#16](https://github.com/bdlukaa/native_admob_flutter/issues/16) and revert [#11/786244151](https://github.com/bdlukaa/native_admob_flutter/issues/11#issuecomment-786244151))
- **FIX** Load native and banner when added to the tree only if not loaded
- **FIX** Listen to events only before loading native and banner ads
- **NEW** `BannerAdOptions.reloadWhenUnitIdChanges`
- **BREAKING** Removed `BannerAdOptions.reloadWhenOrientationChanges`
- **NEW** `AdView.elevation` and `AdView.elevationColor`

## [0.9.4] - [27/02/2021]

- **FIX** Apply height to BannerAd only when it's loaded. (Fixes [#11/786244151](https://github.com/bdlukaa/native_admob_flutter/issues/11#issuecomment-786244151))
- **FIX** Make sure the SDK is initialized when verifying the os version. (Fixes [#8](https://github.com/bdlukaa/native_admob_flutter/issues/8))
- **WIKI** **NEW** Incompatibility with other admob dependencies (Fixes [#4](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-native-ad#incompatibility-with-other-admob-dependencies))
- **NEW** `useHybridComposition` parameter in the constructor of both `NativeAd` and `BannerAd`
- **WORKAROUND** `useHybridComposition` defaults to `true` in android. (See [#16](https://github.com/bdlukaa/native_admob_flutter/issues/16) for more info)

## [0.9.3] - [25/02/2021]

- **NEW**
  - `unitId` parameter in the `NativeAd` widget. (Fixes [#14/785424875](https://github.com/bdlukaa/native_admob_flutter/issues/14#issuecomment-785424875))
  - `unitId` paramer in the `AppOpenAd`, `RewardedAd` and `InterstitialAd` constructor.
  - `loadTimeout` parameter in all the ads. (Fixes [#14/785435140](https://github.com/bdlukaa/native_admob_flutter/issues/15#issuecomment-785435140))
  - `delayToShow` parameter in `NativeAd` and `BannerAd`. (Fixes [#11](https://github.com/bdlukaa/native_admob_flutter/issues/11))
- **FIXED** `BannerAdOptions.reloadWhenSizeChanges` now works properly
- Wiki:
  - [Incompatibility with other admob dependencies](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-native-ad#incompatibility-with-other-admob-dependencies)

## [0.9.2] - [21/02/2021]

- **PERFORMANCE**
  - **BREAKING** Do not use xml layout for native ad anymore (You may need to run `flutter clean` to build the app again)
  - Close the stream subscription to free up resources
- **FIXED**
  - Added a delay to show the android platform view (Virtual Display). (Fixes [#11](https://github.com/bdlukaa/native_admob_flutter/issues/11))
  - Check if the widget is `mounted` before trying to `setState`
  - Banner height is only applied to `BannerAd` only when it's loaded. (Fixed [#11/783862567](https://github.com/bdlukaa/native_admob_flutter/issues/11#issuecomment-783862567))

## [0.9.1+1] - [18/02/2021]

- Remove the iOS support label from pub.dev (Fixes [#9](https://github.com/bdlukaa/native_admob_flutter/issues/9#issuecomment-781496080))

## [0.9.1] - [15/02/2021]

- Added a splashscreen to the example app (Fixes [#7](https://github.com/bdlukaa/native_admob_flutter/issues/7))
- [Wiki](https://github.com/bdlukaa/native_admob_flutter/wiki/):
  - [Consider adding a splashscreen](https://github.com/bdlukaa/native_admob_flutter/wiki/Platform-setup#consider-adding-a-splash-screen)

## [0.9.0] - [14/02/2021]

- **BREAKING**:
  - Removed `InterstitialAdEvent` and `AppOpenAdEvent`
  - Removed `AdError.domain`
- **NEW**: `FullScreenAdEvent`
- Improved documentation
- [Wiki](https://github.com/bdlukaa/native_admob_flutter/wiki)
  - Updated wiki about `RewardedAd` latest update
  - **NEW**: [Consider using Native Ads over Banner Ads](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad#consider-using-native-ads-over-banner-ads)
- **FIXED**:
  - AdError could not parse json from platform side. Now `loadFailed` and`showFailed` works correctly and the `error` placeholder is shown properly

## [0.8.2] - [14/02/2021]

- **BREAKING**:
  - Removed `AdError.cause`. It was giving a StackOverflowError on the android side. (Fixed [#6](https://github.com/bdlukaa/native_admob_flutter/issues/6))

## [0.8.1] - [13/02/2021]

- Make sure the controller is not attached only when trying to attach. (Fixed [#5](https://github.com/bdlukaa/native_admob_flutter/issues/5))
- Formatted files and improved documentation
- [Example app](example/):
  - Added Material elevation to native ads
  - Added an example using Navigator

## [0.8.0] - [11/02/2021]

- **NEW**:
  - `AdView.copyWith`. Now native ads have default values that will only be overritten if done manually. (Fixes [#4](https://github.com/bdlukaa/native_admob_flutter/issues/4))
  - `BannerAdOptions`
  - `force` on load methods
  - `isLoaded` on banner and native controller
- **HIGHLIGHT**: Automatically detect the orientation of the device when loading and set App Open Ad orientation accordingly. Previosly, if your app was in landscape mode and the orientation was set to portrait, the app would go to the portrait orientation
- Example app:
  - Force reload ads if they're long pressed
  - Added a `RefreshIndicator` to the full screen ads page
- Improved documentation and formatted files

## [0.7.2] - [10/02/2021]

- Improved documentation and formatted files
- Make sure to check if the native ad is not disposed instead of attached
- [profile mode](https://flutter.dev/docs/testing/build-modes#profile) is now considered as test mode
- Avoid `RewardedAd`s from receiving events if disposed
- Ensure the SDK is initialized before using it (`MobileAds.initialize`)
- New `AttachableMixin`
- Disattach the controller on dispose
- `MobileAds`
  - Make constructor private
  - Add android version checking on initialize (min version is 16)
  - Fixed `setAppMuted` error
  - Added `RATING_G`, `RATING_PG`, `RATING_T` and `RATING_MA` consts to support `setMaxAdContentRating`
  - Param on `setAppMuted` is now optional. `true` by default
- Added internet permission to example app

## [0.7.1] - [08/02/2021]

- [Banner Ads](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad):
  - **NEW**: You can now set the unitId in the `BannerAd` constructor using `unitId`
  - **BREAKING**: Removed `undefined` from `BannerAdEvent`
- [Native Ads](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-native-ad)
  - Migrate deprecated depedencies. [migration](https://developers.google.com/admob/android/migration)
  - **NEW**: Added `unmuted` in `NativeAdEvent`
  - **BREAKING in NativeAdEvent**:
    - Removed `clicked` and `impression`
    - Renamed `mute` to `muted`
  - Make sure to use a valid reason on [Custom Mute This Ad](https://github.com/bdlukaa/native_admob_flutter/wiki/Custom-mute-this-ad)
- Only dispose controller if it was created by the ad
- Disattach the controller when the banner ad is disposed
- [Wiki (Documentation)](https://github.com/bdlukaa/native_admob_flutter/wiki):
  - Make sure to follow the new Interstitial and Rewarded Ads apis
  - Fixed broken links
  - Removed Native Video Ad
  - **NEW**: Ad Errors
- Updated documentation and formatted all the files
- Simplified example

## 0.7.0 - [06/02/2021]

- Migrated to SDK v20 on Android
- **BREAKING CHANGES on Interstitial and Rewarded ads**:
  - Can NOT set the unit id in the constructor anymore.
  - Removed `undefined`, `leftApplication` and `clicked` from events
  - Removed `createAndLoad` from Rewarded Ads
  - Renamed `opened` -> `showed`
  - Added `showFailed`
  - Unable to use `rewardedAd.rewardedItem` anymore
- **FIXED**:
  - Ads were being loaded forever once it loads once. Now when you show an ad it gets unloaded
- **NEW**:
  - Rewarded ads can be reusable now

## 0.6.1 - [05/02/2021]

- `LoadShowAd` and `UniqueKeyMixin` are now public
- Improved class documentation
- Formatted code
- Preview implementation for iOS.

## 0.6.0+1 - [04/02/2021]

- Improve pub score

## 0.6.0 - [04/02/2021]

- **NEW**:
  - `MediaContent.copyWith()`
  - Ads and Controllers are now inherited from `LoadShowAd` to avoid boilerplate code
  - All `load()` and `show()` methods returns a `Future<bool>` where `true` is success and `false` is error
  - Add all test ids in its respective ad classes
- **FIXED**:
  - Controllers could keep receiving events from the platform side after being disposed
  - Media aspect ratio was not set when trying to set
  - Fixed `adBannerLayoutBuilder` screenshot on the documentation
  - Null issue on the android side when releasing an activity
- Throws an `AssertionError` if you try to use a different type in `AdGradient`
- Highly improved the documentation and wiki

## 0.5.0 - [04/02/2021]

- **NEW**:
  - Implementation for [AppOpenAd](https://developers.google.com/admob/android/app-open-ads)s
  - [Wiki page for AppOpenAds](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-an-app-open-ad)
  - New mixin [UniqueKeyMixin] to implement a unique id to classes
  - `MobileAds.isTestDevice` method
    <!-- This has been done to improve performance. -->
    <!-- Previously, each Ad (Banner, Interstitial...) had to create its own -->
    <!-- Channel instance. That would cause a lot of unnecessary use of resources -->
  - The plugin channel is now public accessible in `MobileAds.pluginChannel`
- **Fixed**: showing warning when a production ad was used in testing (debug)
- Improved documentation on `AdError`s to support `AppOpenAd`s error codes
- Removed the native video ad gif <!-- The gif was too big -->
- Updated example:
  - Now it shows an example of how to use a Banner ad in the bottom of the screen with a bottom bar
  - The example is now fully documentated
  - Added `AppOpenAd` to full-screen ads

## 0.4.2 - [29/01/2021]

- Add declarative support for iOS, even tho it's not supported
- Internet permission documentated

## 0.4.1 - [23/01/2021]

- **NEW**: Native Video Ad gif
- Code refactor

## 0.4.0 - [23/01/2021]

- **NEW**:
  - `rewardedAdUnitId` in `MobileAds.initialize()` is now possible
  - Implementation for `Native and Interstitial Video Ad Ids`
- **FIXED**:
  - Rating bar sizes
  - AdError compiling issue when coming from android
- Removed tooltip text
- Documentation and wiki update
- Improved error messages
- Shows a warning if Production Ads are used in debug mode (`kDebugMode`)
- Version checking is done on build method now because Native and Banner Ads requires Android Api >= 19, but Interstitial and Rewarded requires Android Api >= 16. Required version for iOS is 9
- Pre-support for iOS:
  - [Required flutter version >= 1.22.0](https://flutter.dev/docs/development/platform-integration/platform-views?tab=android-platform-views-kotlin-tab#ios)
  - [Added iOS test ids getters](https://developers.google.com/admob/ios/test-ads#demo_ad_units)
  - [Target version needs to be 9 or higher](https://developers.google.com/admob/ios/quick-start#prerequisites)
  - [Updated wiki with iOS platform setup steps](https://github.com/bdlukaa/native_admob_flutter/wiki/Platform-setup#ios)

## 0.3.1 - [18/91/2021]

- **NEW**: `AdError` instead of only `errorCode`
- You can now `await` the `show()` method from `RewardedAd` and `InterstitialAd`
- Improved documentation
- Now disposed controllers throw an `AssertionError` if used

## 0.3.0 - [17/01/2021]

- **NEW**: Rewarded ads
- Removed unused methods from interstitial

## 0.2.0+1 - [17/01/2021]

- Banner Ad Builder is only applied if loaded

## 0.2.0 - [17/01/2021]

- **NEW**:
  - InterstitialAd
  - Adaptive Banner Ads

## 0.1.2+1 - [15/01/2021]

- Readme update
- All AdViews are documentated now
- Deprecate `SMART_BANNER`, as it's deprecated in SDK v20
  - See [this](https://developers.google.com/admob/android/migration#smart)

## 0.1.2 - [15/01/2021]

- **NEW**:
  - `AdSingleChildView`. Equivalent to `SingleChildView`
  - `AdExpanded`. Equivalent to `Expanded`
- Use `AdDecoration` for decorating `AdView`s
- Changed the default native ad layout builder design to make it more like [this](https://developers.google.com/admob/android/banner/adaptive#when_to_use_adaptive_banners)
- `Loading` and `Error` placeholders are now avaiable on `BannerAd`s
- Updated example app. It's more clear and more intuitive to use

## 0.1.1 - [14/01/2021]

- Documentation improvement

## 0.1.0 - [14/01/2021]

- **NEW**: BannerAds
- **BREAKING**:
  - Rename `AdEvent` to `NativeAdEvent`
  - Rename `NativeAds` to `MobileAds`
- Size is only applied to the ad, not the builder

## 0.0.8+1 - [11/01/2021]

- Implement ad builder

## 0.0.8 - [11/01/2021]

- Implement MediaContent
- Fixed mute this ad info

## 0.0.7 - [06/01/2021]

- **HIGHLIGHT**: Automatic support for Hybrid Composition on android
- Removed custom mute this button from native side
- Removed web implementation
- Improved readme
- Improve view size calculation and warnings

## 0.0.6+4 - [05/01/2021]

- Improved documentation

## 0.0.6+3 - [04/01/2021]

- Update the documentation
- Created the wiki

## 0.0.6+2 - [03/01/2021]

- Fix custom this ad reasons
- Implemented `isCustomMuteThisAdEnabled` on controller

## 0.0.6+1 - [03/01/2021]

- Custom mute this ad is still avaiable but you can't use a `AdView` for it

## 0.0.6 - [02/01/2021]

- Implementation for NativeAdOptions
  - **HIGHLIGHT**: adChoicesPlacement
  - **HIGHLIGHT**: mediaAspectRatio
  - **HIGHLIGHT**: requestCustomMuteThisAd
  - returnUrlsForImageAssets
  - requestMultipleImages
  - videoOptions
- Implement custom mute this ad
- Performance update

## 0.0.5 - [02/01/2021]

- Implementation for new methods
  - **HIGHLIGHT**: setChildDirected
  - **HIGHLIGHT**: setTagForUnderAgeOfConsent
  - **HIGHLIGHT**: setMaxAdContentRating
  - setAppVolume
  - setAppMuted
- Improved documentation
- Preparation for `Custom Mute this Ad` and `Native Video Ads`

## 0.0.4+1 - [01/01/2021]

- Portuguese translation
- Improvoved documentation
- Remove useless files

## 0.0.4 - [31/12/2020]

- Button text style is now customizable
- Fixed `Colors.transparent` color bug

## 0.0.3+1

- Added layout gravity
- Changed examples to support hot reload

## 0.0.3 - [31/12/2020]

- Remove context from builder
- Changing the layout during runtime is now supported 🥳🥳🎉

## 0.0.2 - [30/12/2020]

- Add Linear and Radial Gradient

## 0.0.1+1 - [30/12/2020]

- Fix some issues

## 0.0.1 - [29/12/2020]

- Initial release
