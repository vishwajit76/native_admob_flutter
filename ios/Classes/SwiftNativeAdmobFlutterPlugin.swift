import Flutter
import UIKit
import GoogleMobileAds


let controllerManager = InterstitialAdControllerManager.shared

public class SwiftNativeAdmobFlutterPlugin: NSObject, FlutterPlugin {
    
    let messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
            self.messenger = messenger
        }

  public static func register(with registrar: FlutterPluginRegistrar) {
    //messenger = registrar.messenger()
    let channel = FlutterMethodChannel(name: "native_admob_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftNativeAdmobFlutterPlugin(messenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.register(BannerAdViewFactory(messenger: registrar.messenger()), withId: "banner_admob")
  }
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let params = call.arguments as? Dictionary<String, Any>
    switch call.method {
      case "initialize":
        GADMobileAds.sharedInstance().start { (status: GADInitializationStatus) in
                   print("iOS Admob status: \(status.adapterStatusesByClassName)")
               }
        result(ProcessInfo().operatingSystemVersion.majorVersion)

      // Native Ad
      case "initNativeAdController": 
        NativeAdControllerManager.shared.createController(forID: params?["id"] as! String, binaryMessenger: messenger)
        result(nil)
      case "disposeNativeAdController":
        NativeAdControllerManager.shared.removeController(forID: params?["id"] as! String)
        result(nil)

      // Banner Ad
      case "initBannerAdController":
        BannerAdControllerManager.shared.createController(forID: params?["id"] as! String, binaryMessenger: messenger)
        result(nil)
      case "disposeBannerAdController":
        BannerAdControllerManager.shared.removeController(forID: params?["id"] as! String)
        result(nil)

       //Interstitial Ad
      case "initInterstitialAd":
        InterstitialAdControllerManager.shared.createController(forID: params?["id"] as! String, binaryMessenger: messenger)
        result(nil)
        
      case "disposeInterstitialAd":
        InterstitialAdControllerManager.shared.removeController(forID: params?["id"] as! String)
        result(nil)
      
      // Rewarded Ad
      case "initRewardedAd":
        RewardedAdControllerManager.shared.createController(forID: params?["id"] as! String, binaryMessenger: messenger)
        result(nil)
      case "disposeRewardedAd":
        RewardedAdControllerManager.shared.removeController(forID: params?["id"] as! String)
        result(nil)

      // App Open 
      case "initAppOpenAd":
        AppOpenAdControllerManager.shared.createController(forID: params?["id"] as! String, binaryMessenger: messenger)
        result(nil)
      case "disposeAppOpenAd":
        AppOpenAdControllerManager.shared.removeController(forID: params?["id"] as! String)
        result(nil)
      
      // General
      case "isTestDevice":
        result(true)
      
      case "setTestDeviceIds":
        GADMobileAds
          .sharedInstance()
          .requestConfiguration
            .testDeviceIdentifiers = (params?["ids"] as! [String])
        result(nil)

      case "setChildDirected":
        GADMobileAds
          .sharedInstance()
          .requestConfiguration
          .tag(forChildDirectedTreatment: params?["directed"] as! Bool)
        result(nil)

      case "setTagForUnderAgeOfConsent":
         GADMobileAds
           .sharedInstance()
           .requestConfiguration
           .tagForUnderAge(ofConsent: params?["under"] as! Bool)
        result(nil)

      case "setMaxAdContentRating":
        var maxAdContentRating = GADMaxAdContentRating.general
        switch params?["maxRating"] as! Int {
        case 0 :
            maxAdContentRating=GADMaxAdContentRating.general
        case 1 :
            maxAdContentRating=GADMaxAdContentRating.parentalGuidance
        case 2 :
            maxAdContentRating=GADMaxAdContentRating.teen
        case 3 :
            maxAdContentRating=GADMaxAdContentRating.matureAudience
        default :
            maxAdContentRating=GADMaxAdContentRating.general
        }
        GADMobileAds
          .sharedInstance()
            .requestConfiguration.maxAdContentRating=maxAdContentRating
       result(nil)

      case "setAppVolume":
        GADMobileAds.sharedInstance().applicationVolume = params?["volume"] as! Float
        result(nil)

      case "setAppMuted":
        GADMobileAds.sharedInstance().applicationMuted = params?["muted"]as! Bool
        result(nil)

      default:
        result(FlutterMethodNotImplemented)
    }
  }
}
