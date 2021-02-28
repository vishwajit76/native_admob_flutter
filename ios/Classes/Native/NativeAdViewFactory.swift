import Flutter
import GoogleMobileAds

class NativeAdViewFactory : NSObject,FlutterPlatformViewFactory {
    let messenger: FlutterBinaryMessenger

       init(messenger: FlutterBinaryMessenger) {
           self.messenger = messenger
       }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let creationParams = args as? Dictionary<String, Any>
        return NativeAdView(data: creationParams,messenger:messenger)
    }
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}
