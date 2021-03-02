import Foundation

class UIGradientStackView: UIStackView {
    
    private let gradientLayer : CAGradientLayer = CAGradientLayer()
    private var gradientStartColor: UIColor = UIColor(white: 1, alpha: 0)
    private var gradientEndColor: UIColor = UIColor(white: 1, alpha: 0)
    private var startPoint: CGPoint = CGPoint.zero
    private var endPoint: CGPoint = CGPoint.zero
    private var topRight : Float = 0.0
    private var topLeft :Float = 0.0
    private var bottomRight :Float = 0.0
    private var bottomLeft : Float = 0.0
    
    init(data : [String:Any]) {
        if let  gradient = data["gradient"] as? [String:Any], let colors = gradient["colors"] as? Array<String>, let orientation = gradient["orientation"] as? String, let type = gradient["type"] as? String,
           let radialGradientCenterX = gradient["radialGradientCenterX"] as? Float,let radialGradientCenterY = gradient["radialGradientCenterY"] as? Float
           ,let radialGradientRadius = gradient["radialGradientRadius"] as? Int
        {
            self.gradientStartColor = UIColor(hexString: colors[1])
            self.gradientEndColor = UIColor(hexString: colors[0])
            switch orientation{
            case "top_bottom" :
                self.startPoint = CGPoint(x: 0.5, y: 0.0);
                self.endPoint = CGPoint(x: 0.5, y: 1.0);
            case "tr_bl" :
                self.startPoint = CGPoint(x: 1.0, y: 0.0);
                self.endPoint = CGPoint(x: 0.0, y: 1.0);
            case "right_left" :
                self.startPoint = CGPoint(x: 1.0, y: 0.5);
                self.endPoint = CGPoint(x: 0.0, y: 0.5);
            case "br_tl" :
                self.startPoint = CGPoint(x: 1.0, y: 1.0);
                self.endPoint = CGPoint(x: 0.0, y: 0.0);
            case "bottom_top" :
                self.startPoint = CGPoint(x: 0.5, y: 1.0);
                self.endPoint = CGPoint(x: 0.5, y: 0.0);
            case "bl_tr" :
                self.startPoint = CGPoint(x: 0.0, y: 1.0);
                self.endPoint = CGPoint(x: 1.0, y: 0.0);
            case "left_right" :
                self.startPoint = CGPoint(x: 0.0, y: 0.5);
                self.endPoint = CGPoint(x: 1.0, y: 0.5);
            case "tl_br" :
                self.startPoint = CGPoint(x: 0.0, y: 0.0);
                self.endPoint = CGPoint(x: 1.0, y: 1.0);
            default:
                self.startPoint = CGPoint(x: 0.0, y: 0.5);
                self.endPoint = CGPoint(x: 1.0, y: 0.5);
            }
            
            switch type{
            case "linear" :
                gradientLayer.type = .axial
            case "radial" :
                gradientLayer.type = .radial
                gradientLayer.locations = [0.0,1.0]
                self.startPoint=CGPoint(x: CGFloat(radialGradientCenterX), y: CGFloat(radialGradientCenterY))
                self.endPoint=CGPoint(x: 1, y: 1)
                
            default:
                gradientLayer.type=CAGradientLayerType.axial
            }
        }
        
        if let borderWidth = data["borderWidth"] as? Double{
            gradientLayer.borderWidth=CGFloat(borderWidth);
        }
        
        if let borderColor = data["borderColor"] as? String{
            gradientLayer.borderColor=UIColor(hexString: borderColor).cgColor
        }
        
        if let topRight = data["topRightRadius"] as? Float{
            self.topRight = topRight
        }
        
        if let bottomLeft = data["bottomLeftRadius"] as? Float{
            self.bottomLeft = bottomLeft
        }
        
        if let topLeft = data["topLeftRadius"] as? Float{
            self.topLeft = topLeft
        }
        
        if let bottomRight = data["bottomRightRadius"] as? Float{
            self.bottomRight = bottomRight
        }
        
        if let borderColor = data["borderColor"] as? String{
            gradientLayer.borderColor=UIColor(hexString: borderColor).cgColor
        }
        
        super.init(frame: .zero)
        
        
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = self.bounds
        roundAllCorners()
    }
    
    override public func draw(_ rect: CGRect) {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [gradientEndColor.cgColor, gradientStartColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func roundAllCorners(){
        roundCorners(corners: [.topLeft], radius: CGFloat(topLeft))
        roundCorners(corners: [.topRight], radius: CGFloat(topRight))
        roundCorners(corners: [.bottomRight], radius: CGFloat(bottomRight))
        roundCorners(corners: [.bottomLeft], radius: CGFloat(bottomLeft))
    }
}

class UIGradientButton: UIButton {
    
    private let gradientLayer : CAGradientLayer = CAGradientLayer()
    private var gradientStartColor: UIColor = UIColor(white: 1, alpha: 0)
    private var gradientEndColor: UIColor = UIColor(white: 1, alpha: 0)
    private var startPoint: CGPoint = CGPoint.zero
    private var endPoint: CGPoint = CGPoint.zero
    private var topRight : Float = 0.0
    private var topLeft :Float = 0.0
    private var bottomRight :Float = 0.0
    private var bottomLeft : Float = 0.0
    
    init(data : [String:Any]) {
        if let  gradient = data["gradient"] as? [String:Any], let colors = gradient["colors"] as? Array<String>, let orientation = gradient["orientation"] as? String, let type = gradient["type"] as? String,
           let radialGradientCenterX = gradient["radialGradientCenterX"] as? Float,let radialGradientCenterY = gradient["radialGradientCenterY"] as? Float
           ,let radialGradientRadius = gradient["radialGradientRadius"] as? Int
        {
            self.gradientStartColor = UIColor(hexString: colors[1])
            self.gradientEndColor = UIColor(hexString: colors[0])
            switch orientation{
            case "top_bottom" :
                self.startPoint = CGPoint(x: 0.5, y: 0.0);
                self.endPoint = CGPoint(x: 0.5, y: 1.0);
            case "tr_bl" :
                self.startPoint = CGPoint(x: 1.0, y: 0.0);
                self.endPoint = CGPoint(x: 0.0, y: 1.0);
            case "right_left" :
                self.startPoint = CGPoint(x: 1.0, y: 0.5);
                self.endPoint = CGPoint(x: 0.0, y: 0.5);
            case "br_tl" :
                self.startPoint = CGPoint(x: 1.0, y: 1.0);
                self.endPoint = CGPoint(x: 0.0, y: 0.0);
            case "bottom_top" :
                self.startPoint = CGPoint(x: 0.5, y: 1.0);
                self.endPoint = CGPoint(x: 0.5, y: 0.0);
            case "bl_tr" :
                self.startPoint = CGPoint(x: 0.0, y: 1.0);
                self.endPoint = CGPoint(x: 1.0, y: 0.0);
            case "left_right" :
                self.startPoint = CGPoint(x: 0.0, y: 0.5);
                self.endPoint = CGPoint(x: 1.0, y: 0.5);
            case "tl_br" :
                self.startPoint = CGPoint(x: 0.0, y: 0.0);
                self.endPoint = CGPoint(x: 1.0, y: 1.0);
            default:
                self.startPoint = CGPoint(x: 0.0, y: 0.5);
                self.endPoint = CGPoint(x: 1.0, y: 0.5);
            }
            
            switch type{
            case "linear" :
                gradientLayer.type = .axial
            case "radial" :
                gradientLayer.type = .radial
                gradientLayer.locations = [0.0,1.0]
                self.startPoint=CGPoint(x: CGFloat(radialGradientCenterX), y: CGFloat(radialGradientCenterY))
                self.endPoint=CGPoint(x: 1, y: 1)
                
            default:
                gradientLayer.type=CAGradientLayerType.axial
            }
        }
        
        if let borderWidth = data["borderWidth"] as? Double{
            gradientLayer.borderWidth=CGFloat(borderWidth);
        }
        
        if let borderColor = data["borderColor"] as? String{
            gradientLayer.borderColor=UIColor(hexString: borderColor).cgColor
        }
        
        if let topRight = data["topRightRadius"] as? Float{
            self.topRight = topRight
        }
        
        if let bottomLeft = data["bottomLeftRadius"] as? Float{
            self.bottomLeft = bottomLeft
        }
        
        if let topLeft = data["topLeftRadius"] as? Float{
            self.topLeft = topLeft
        }
        
        if let bottomRight = data["bottomRightRadius"] as? Float{
            self.bottomRight = bottomRight
        }
        
        if let borderColor = data["borderColor"] as? String{
            gradientLayer.borderColor=UIColor(hexString: borderColor).cgColor
        }
        
        super.init(frame: .zero)
        
        
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = self.bounds
        roundAllCorners()
    }
    
    override public func draw(_ rect: CGRect) {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [gradientEndColor.cgColor, gradientStartColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func roundAllCorners(){
        roundCorners(corners: [.topLeft], radius: CGFloat(topLeft))
        roundCorners(corners: [.topRight], radius: CGFloat(topRight))
        roundCorners(corners: [.bottomRight], radius: CGFloat(bottomRight))
        roundCorners(corners: [.bottomLeft], radius: CGFloat(bottomLeft))
    }
}

class UIGradientLabel: UILabel {
    
    private let gradientLayer : CAGradientLayer = CAGradientLayer()
    private var gradientStartColor: UIColor = UIColor(white: 1, alpha: 0)
    private var gradientEndColor: UIColor = UIColor(white: 1, alpha: 0)
    private var startPoint: CGPoint = CGPoint.zero
    private var endPoint: CGPoint = CGPoint.zero
    private var topRight : Float = 0.0
    private var topLeft :Float = 0.0
    private var bottomRight :Float = 0.0
    private var bottomLeft : Float = 0.0
    
    init(data : [String:Any]) {
        if let  gradient = data["gradient"] as? [String:Any], let colors = gradient["colors"] as? Array<String>, let orientation = gradient["orientation"] as? String, let type = gradient["type"] as? String,
           let radialGradientCenterX = gradient["radialGradientCenterX"] as? Float,let radialGradientCenterY = gradient["radialGradientCenterY"] as? Float
           ,let radialGradientRadius = gradient["radialGradientRadius"] as? Int
        {
            self.gradientStartColor = UIColor(hexString: colors[1])
            self.gradientEndColor = UIColor(hexString: colors[0])
            switch orientation{
            case "top_bottom" :
                self.startPoint = CGPoint(x: 0.5, y: 0.0);
                self.endPoint = CGPoint(x: 0.5, y: 1.0);
            case "tr_bl" :
                self.startPoint = CGPoint(x: 1.0, y: 0.0);
                self.endPoint = CGPoint(x: 0.0, y: 1.0);
            case "right_left" :
                self.startPoint = CGPoint(x: 1.0, y: 0.5);
                self.endPoint = CGPoint(x: 0.0, y: 0.5);
            case "br_tl" :
                self.startPoint = CGPoint(x: 1.0, y: 1.0);
                self.endPoint = CGPoint(x: 0.0, y: 0.0);
            case "bottom_top" :
                self.startPoint = CGPoint(x: 0.5, y: 1.0);
                self.endPoint = CGPoint(x: 0.5, y: 0.0);
            case "bl_tr" :
                self.startPoint = CGPoint(x: 0.0, y: 1.0);
                self.endPoint = CGPoint(x: 1.0, y: 0.0);
            case "left_right" :
                self.startPoint = CGPoint(x: 0.0, y: 0.5);
                self.endPoint = CGPoint(x: 1.0, y: 0.5);
            case "tl_br" :
                self.startPoint = CGPoint(x: 0.0, y: 0.0);
                self.endPoint = CGPoint(x: 1.0, y: 1.0);
            default:
                self.startPoint = CGPoint(x: 0.0, y: 0.5);
                self.endPoint = CGPoint(x: 1.0, y: 0.5);
            }
            
            switch type{
            case "linear" :
                gradientLayer.type = .axial
            case "radial" :
                gradientLayer.type = .radial
                gradientLayer.locations = [0.0,1.0]
                self.startPoint=CGPoint(x: CGFloat(radialGradientCenterX), y: CGFloat(radialGradientCenterY))
                self.endPoint=CGPoint(x: 1, y: 1)
                
            default:
                gradientLayer.type=CAGradientLayerType.axial
            }
        }
        
        if let borderWidth = data["borderWidth"] as? Double{
            gradientLayer.borderWidth=CGFloat(borderWidth);
        }
        
        if let borderColor = data["borderColor"] as? String{
            gradientLayer.borderColor=UIColor(hexString: borderColor).cgColor
        }
        
        if let topRight = data["topRightRadius"] as? Float{
            self.topRight = topRight
        }
        
        if let bottomLeft = data["bottomLeftRadius"] as? Float{
            self.bottomLeft = bottomLeft
        }
        
        if let topLeft = data["topLeftRadius"] as? Float{
            self.topLeft = topLeft
        }
        
        if let bottomRight = data["bottomRightRadius"] as? Float{
            self.bottomRight = bottomRight
        }
        
        if let borderColor = data["borderColor"] as? String{
            gradientLayer.borderColor=UIColor(hexString: borderColor).cgColor
        }
        
        super.init(frame: .zero)
        
        
    }
    
    required init(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = self.bounds
        roundAllCorners()
    }
    
    override public func draw(_ rect: CGRect) {
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [gradientEndColor.cgColor, gradientStartColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        if gradientLayer.superlayer == nil {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    func roundAllCorners(){
        roundCorners(corners: [.topLeft], radius: CGFloat(topLeft))
        roundCorners(corners: [.topRight], radius: CGFloat(topRight))
        roundCorners(corners: [.bottomRight], radius: CGFloat(bottomRight))
        roundCorners(corners: [.bottomLeft], radius: CGFloat(bottomLeft))
    }
}

