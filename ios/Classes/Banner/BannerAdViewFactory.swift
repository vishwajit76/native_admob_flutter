import Flutter
import GoogleMobileAds

class BannerAdViewFactory : NSObject,FlutterPlatformViewFactory {
    let messenger: FlutterBinaryMessenger

       init(messenger: FlutterBinaryMessenger) {
           self.messenger = messenger
       }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let creationParams = args as? Dictionary<String, Any>
        return BannerAdView(data: creationParams,messenger:messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}
