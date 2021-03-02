import Flutter
import GoogleMobileAds

class NativeAdView : NSObject,FlutterPlatformView {
    
    var data:[String:Any]?
    private let channel: FlutterMethodChannel
    
    private var adView: GADNativeAdView
    
    private var ratingBar: UIImageView? = UIImageView()
    private var adMedia: GADMediaView? = GADMediaView()
    private var adIcon: UIImageView? = UIImageView()
    private var adHeadline: UILabel? = UILabel()
    private var adAdvertiser: UILabel? = UILabel()
    private var adBody: UILabel? = UILabel()
    private var adPrice: UILabel? = UILabel()
    private var adStore: UILabel? = UILabel()
    private var adAttribution: UILabel? = UILabel()
    private var callToAction: UIButton? = UIButton()
    
    private var controller: NativeAdController? = nil
    
    
    init(data: [String:Any]?, messenger: FlutterBinaryMessenger) {
        self.data=data
        channel = FlutterMethodChannel(name: "native_admob", binaryMessenger: messenger)
        self.adView=GADNativeAdView()
        super.init()
        adView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        let builtView = buildView(data: data!)
        self.adView.addSubview(builtView)
        builtView.topAnchor.constraint(equalTo: adView.topAnchor).isActive = true
        builtView.bottomAnchor.constraint(equalTo: adView.bottomAnchor).isActive = true
        builtView.leftAnchor.constraint(equalTo: adView.leftAnchor).isActive = true
        builtView.rightAnchor.constraint(equalTo: adView.rightAnchor).isActive = true
        adView.layoutIfNeeded()
        define()
        if let controllerId = data?["controllerId"] as? String,
           let controller = NativeAdControllerManager.shared.getController(forID: controllerId) {
            self.controller = controller
            controller.nativeAdChanged = setNativeAd
            controller.nativeAdUpdateRequested = { (layout: Dictionary<String, Any>?, ad: GADNativeAd?) -> Void in
                self.adView=GADNativeAdView()
                self.adView.addSubview(self.buildView(data: layout!))
                self.define()
                self.setNativeAd(nativeAd: ad)
            }
        }
        
        if let nativeAd = controller?.nativeAd {
            setNativeAd(nativeAd: nativeAd)
        }
        
    }
    
    private func buildView(data: [String:Any])-> UIView {
        let viewType: String? = data["viewType"] as? String
        var view :UIView = UIView()
        
        if (viewType != nil){
            switch (viewType) {
            case "linear_layout" :
                    view=UIGradientStackView(data: data)
                (view as! UIStackView).distribution = .equalCentering
                view.translatesAutoresizingMaskIntoConstraints=false
                if data["orientation"] as! String == "vertical"{
                    (view as! UIStackView).axis = NSLayoutConstraint.Axis.vertical
                } else {
                    (view as! UIStackView).axis = NSLayoutConstraint.Axis.horizontal
                }
                switch data["gravity"] as? String {
                case "center":
                    (view as! UIStackView).alignment = .center
                case "center_horizontal":
                    (view as! UIStackView).alignment = .center
                case "center_vertical":
                    (view as! UIStackView).alignment = .center
                case "left":
                    (view as! UIStackView).alignment = .leading
                case "right":
                    (view as! UIStackView).alignment = .trailing
                case "top":
                    (view as! UIStackView).alignment = .top
                case "bottom":
                    (view as! UIStackView).alignment = .bottom
                default:
                    (view as! UIStackView).alignment = .top
                }
                if (data["children"] != nil){
                    for child in data["children"] as! Array<Any>{
                        (view as! UIStackView).addArrangedSubview(buildView(data: child as! Dictionary<String, Any>))
                    }
                }
            case "text_view" :
                view=UIGradientLabel(data: data)
            case "image_view" :
                view = UIImageView()
            case "media_view" :
                view = GADMediaView()
            case "rating_bar" :
                view = UIImageView()
            case "button_view" :
                    view=UIGradientButton(data: data)
            case .none:
                print("none")
            case .some(_):
                print("some")
            }
            
        }
        
        // bounds
        let paddingRight = (data["paddingRight"] as? Double)
        let paddingLeft=(data["paddingLeft"] as? Double)
        let paddingTop=(data["paddingTop"] as? Double)
        let paddingBottom=(data["paddingBottom"] as? Double)
        view.layoutMargins=UIEdgeInsets(top: CGFloat(paddingTop ?? 0), left: CGFloat(paddingLeft ?? 0), bottom: CGFloat(paddingBottom ?? 0), right: CGFloat(paddingRight ?? 0))
        

        if let height =  data["height"] as! Float?, let width = data["width"] as! Float? ,width != -1, height != -1, width != -2 {
            view.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            view.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        }
        
        switch data["id"] as! String{
        case "advertiser" : adAdvertiser = view as? UILabel
        case "attribution" : adAttribution = view as? UILabel
        case "body" : adBody = view as? UILabel
        case "button" : callToAction = view as? UIButton
        case "headline" : adHeadline = view as? UILabel
        case "icon" : adIcon = view as? UIImageView
        case "media" : adMedia = view as? GADMediaView
        case "price" : adPrice = view as? UILabel
        case "ratingBar" : ratingBar = view as? UIImageView
        case "store" : adStore = view as? UILabel
        default:
            print("")
        }
                
        return view
    }
    
    func view() -> UIView {
        return adView
    }
    
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
        guard let rating = starRating?.doubleValue else {
            return nil
        }
        if rating >= 5 {
            return UIImage(named: "stars_5")
        } else if rating >= 4.5 {
            return UIImage(named: "stars_4_5")
        } else if rating >= 4 {
            return UIImage(named: "stars_4")
        } else if rating >= 3.5 {
            return UIImage(named: "stars_3_5")
        } else {
            return nil
        }
    }
    
    private func define() {
        self.adView.mediaView = adMedia
        self.adView.headlineView = adHeadline
        self.adView.bodyView = adBody
        self.adView.callToActionView = callToAction
        self.adView.iconView = adIcon
        self.adView.priceView = adPrice
        self.adView.starRatingView = ratingBar
        self.adView.storeView = adStore
        self.adView.advertiserView = adAdvertiser
    }
    
    private func setNativeAd(nativeAd: GADNativeAd?) {
        if (nativeAd == nil){ return}
        
        adMedia?.mediaContent = nativeAd?.mediaContent
        
        (adHeadline)?.text = nativeAd?.headline
        
        (adBody)?.text = nativeAd?.body
        adBody?.isHidden = nativeAd?.body == nil
        
        (callToAction)?.setTitle(nativeAd?.callToAction, for: .normal)
        callToAction?.isHidden = nativeAd?.callToAction == nil
        
        (adIcon)?.image = nativeAd?.icon?.image
        adIcon?.isHidden = nativeAd?.icon == nil
        
        (ratingBar)?.image = imageOfStars(from:nativeAd?.starRating)
        ratingBar?.isHidden = nativeAd?.starRating == nil
        
        (adStore)?.text = nativeAd?.store
        adStore?.isHidden = nativeAd?.store == nil
        
        (adPrice)?.text = nativeAd?.price
        adPrice?.isHidden = nativeAd?.price == nil
        
        (adAdvertiser)?.text = nativeAd?.advertiser
        adAdvertiser?.isHidden = nativeAd?.advertiser == nil
        
        callToAction?.isUserInteractionEnabled = false
        
        adView.nativeAd=nativeAd
    }
    
}
