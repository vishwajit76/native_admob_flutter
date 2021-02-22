import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils.dart';
import 'controller.dart';

import '../../native_admob_flutter.dart';

const _viewType = 'banner_admob';

/// Creates a BannerAd and add it to the widget tree. Uses
/// a [PlatformView] to connect to the AdView in the platform
/// side. Uses:
///   - https://developers.google.com/admob/android/banner on Android
///   - https://developers.google.com/admob/ios/banner on iOS
class BannerAd extends StatefulWidget {
  /// Creates a new Banner Ad.
  /// `size` can NOT be null. If so, an `AssertionError` is thrown
  ///
  /// For more info, read the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad)
  const BannerAd({
    Key key,
    this.builder,
    this.controller,
    this.size = BannerSize.ADAPTIVE,
    this.error,
    this.loading,
    this.unitId,
    this.options = const BannerAdOptions(),
  })  : assert(size != null, 'A size must be set'),
        assert(options != null),
        super(key: key);

  /// The builder of the ad. The ad won't be reloaded if this changes
  ///
  /// DO:
  /// ```dart
  /// BannerAd(
  ///   builder: (context, child) {
  ///     return Container(
  ///       // Applies a blue color to the background.
  ///       // You can use anything here to build the ad.
  ///       // The ad won't be reloaded
  ///       color: Colors.blue,
  ///       child: child,
  ///     );
  ///   }
  /// )
  /// ```
  ///
  /// DON'T:
  /// ```dart
  /// Container(
  ///   color: Colors.blue,
  ///   child: BannerAd(),
  /// )
  /// ```
  ///
  /// For more info, visit the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad#adbuilder)
  final AdBuilder builder;

  /// The error placeholder. If an error happens, this widget will be shown
  ///
  /// For more info, visit the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad#loading-and-error-placeholders)
  final Widget error;

  /// The loading placeholder. This widget will be shown while the ad is loading
  ///
  /// For more info, visit the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad#loading-and-error-placeholders)
  final Widget loading;

  /// The controller of the ad.
  /// This controller must be unique and can be used on only one `BannerAd`
  ///
  /// The ad is loaded automatically when attached and it's not necessary to load it
  /// manually.
  /// You can use the controller to reload the ad:
  /// ```dart
  /// controller.load();
  /// ```
  ///
  /// You can use the controller to listen to events:
  /// ```dart
  /// controller.onEvent.listen((e) {
  ///    final event = e.keys.first;
  ///    final info = e.values.first;
  ///    switch (event) {
  ///     case BannerAdEvent.loading:
  ///       break;
  ///     case BannerAdEvent.loadFailed:
  ///       print(info);
  ///       break;
  ///     case BannerAdEvent.loaded:
  ///       break;
  ///     case BannerAdEvent.undefined:
  ///       break;
  ///     default:
  ///       break;
  ///   }
  /// });
  /// ```
  ///
  /// For more info, visit the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Using-the-controller-and-listening-to-banner-events)
  final BannerAdController controller;

  /// The size of the Ad. `BannerSize.ADAPTIVE` is the default.
  /// This can NOT be null. If so, throws an `AssertionError`
  ///
  /// ## Sizes
  ///
  /// | Name              | `Width`x`Height`   | Availability       |
  /// | ----------------- | ------------------ | ------------------ |
  /// | BANNER            | 320x50             | Phones and Tablets |
  /// | LARGE_BANNER      | 320x100            | Phones and Tablets |
  /// | MEDIUM_RECTANGLE  | 320x250            | Phones and Tablets |
  /// | FULL_BANNER       | 468x60             | Tablets            |
  /// | LEADERBOARD       | 728x90             | Tablets            |
  /// | SMART_BANNER      | `?`x(32, 50, 90)   | Phones and Tablets |
  /// | *ADAPTIVE_BANNER* | `Screen width`x`?` | Phones and Tablets |
  ///
  /// ### Usage
  /// ```dart
  /// BannerAd(
  ///   ...
  ///   size: BannerSize.`Name` /* (`BANNER`, `FULL_BANNER`, etc) */,
  ///   ...
  /// )
  /// ```
  ///
  /// ## Custom size
  /// To define a custom banner size, set your desired `BannerSize`, as shown here:
  /// ```dart
  /// BannerAd(
  ///   ...
  ///                      // width, height
  ///   size: BannerSize.fromWH(300, 50),
  ///   size: BannerSize(Size(300, 50)),
  ///   ...
  /// )
  /// ```
  ///
  /// For more info, visit the [documentation](https://github.com/bdlukaa/native_admob_flutter/wiki/Creating-a-banner-ad#creating-an-ad)
  final BannerSize size;

  /// The unitId used by this `BannerAd`.
  /// If changed after loaded it'll be reloaded with the new ad unit id.\
  /// If null, defaults to `MobileAds.bannerAdUnitId`
  final String unitId;

  final BannerAdOptions options;

  @override
  _BannerAdState createState() => _BannerAdState();
}

class _BannerAdState extends State<BannerAd>
    with AutomaticKeepAliveClientMixin<BannerAd> {
  BannerAdController controller;
  BannerAdEvent state = BannerAdEvent.loading;

  double height;

  BannerAdOptions get options => widget.options;

  @override
  void initState() {
    super.initState();
    attachNewController();
    controller.load();
  }

  // @override
  // void didUpdateWidget(BannerAd oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // if ((oldWidget.unitId == null && widget.unitId != null) ||
  //   //     (oldWidget.unitId != widget.unitId)) {
  //   //   controller.load();
  //   // }
  //   // if (oldWidget.controller == null && widget.controller != null) {
  //   //   attachNewController();
  //   //   controller.changeController(controller.id);
  //   //   controller.load();
  //   // }
  // }

  void attachNewController() {
    controller = widget.controller ?? BannerAdController();
    controller.attach(true);
    controller.onEvent.listen((e) {
      final event = e.keys.first;
      final info = e.values.first;
      switch (event) {
        case BannerAdEvent.loading:
        case BannerAdEvent.loadFailed:
        case BannerAdEvent.loaded:
          if (info is int) height = info.toDouble();
          setState(() => state = event);
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    // dispose the controller only if the controller was
    // created by the ad.
    if (widget.controller == null)
      controller?.dispose();
    else
      controller?.attach(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    assertPlatformIsSupported();
    assertVersionIsSupported();
    assert(options != null, 'You must set the ad options');

    return LayoutBuilder(
      builder: (context, consts) {
        double height = widget.size.size.height;
        double width = widget.size.size.width;

        if (height == -1 && width == -1) {
          width = consts.biggest.width;
        }

        final params = <String, dynamic>{};
        params.addAll({
          'controllerId': controller.id,
          'unitId': widget.unitId ?? MobileAds.bannerAdUnitId,
          'size_height': height ?? -1,
          'size_width': width,
        });

        Widget w;
        if (Platform.isAndroid) {
          w = buildAndroidPlatformView(
            params,
            _viewType,
            MobileAds.useHybridComposition,
          );
        } else if (Platform.isIOS) {
          w = UiKitView(
            viewType: _viewType,
            creationParamsCodec: StandardMessageCodec(),
            creationParams: params,
          );
        } else {
          return SizedBox();
        }

        double finalHeight;
        if (this.height != null && !this.height.isNegative) {
          finalHeight = this.height;
        } else if (!height.isNegative)
          finalHeight = height;
        else /* if (height == -1 && width == -2) */ {
          final screenHeight = MediaQuery.of(context).size.height;
          double height;
          if (screenHeight <= 400)
            height = 32;
          else if (screenHeight > 400 || screenHeight <= 720)
            height = 50;
          else
            height = 90;
          finalHeight = height;
        }

        w = SizedBox(height: finalHeight, child: w);
        if (state == BannerAdEvent.loaded)
          w = widget.builder?.call(context, w) ?? w;

        w = Stack(
          children: [
            w,
            if (state == BannerAdEvent.loading) widget.loading ?? SizedBox(),
            if (state == BannerAdEvent.loadFailed) widget.error ?? SizedBox(),
          ],
        );

        return w;
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
