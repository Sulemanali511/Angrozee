//
//  UIFont.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import UIKit

struct Font {
    static var fontSize:CGFloat = 2
}

struct AppFontName {
    
    static var light = "NeueHaasDisplay-Light"
    static var thin = "NeueHaasDisplay-Thin"
    static var heavy = "NeueHaasDisplay-Black"
    static var regular = "NeueHaasDisplay-Roman"
    static var bold = "NeueHaasDisplay-Mediu"
    static var medium = "NeueHaasDisplay-Bold"
    static var italic = "NeueHaasDisplay-LightItalic"
    
}

extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

extension UIFont {
    
    @objc class func mySystemFont(ofSize size: CGFloat,weight: UIFont.Weight) -> UIFont {
        //        return UIFont(name: AppFontName.regular, size: size)!
        switch weight {
        case .heavy:
            return UIFont(name: AppFontName.heavy, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
        case .black:
            return UIFont(name: AppFontName.medium, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
        case .thin:
            return UIFont(name: AppFontName.thin, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
        case .light:
            return UIFont(name: AppFontName.light, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
        case .ultraLight:
            return UIFont(name: AppFontName.italic, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
            
            
        default:
            return UIFont(name: AppFontName.regular, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
        }
        
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        //        return UIFont(name: AppFontName.regular, size: size)!
        return UIFont(name: AppFontName.regular, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
    }
    
    
    
    @objc class func myBoldSystemFont(ofSize size: CGFloat) -> UIFont {
        //        return UIFont(name: AppFontName.bold, size: size)!
        return UIFont(name: AppFontName.bold, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
    }
    
    @objc class func myItalicSystemFont(ofSize size: CGFloat) -> UIFont {
        //        return UIFont(name: AppFontName.semibold, size: size)!
        return UIFont(name: AppFontName.italic, size: Font.fontSize+size) ?? systemFont(ofSize: Font.fontSize+size)
    }
    @objc convenience init?(myCoder aDecoder: NSCoder) {
        
        //print("test")
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String else {
                self.init(myCoder: aDecoder)
                return
        }
        
        
        var fontName = ""
        
        switch fontAttribute {
        case "CTFontRegularUsage":
            fontName = AppFontName.regular
        case "CTFontHeavyUsage":
            fontName = AppFontName.heavy
        case "CTFontBlackUsage":
            fontName = AppFontName.medium
        case "CTFontBoldUsage":
            fontName = AppFontName.bold
        case "CTFontLightUsage":
            fontName = AppFontName.light
        case "CTFontThinUsage":
            fontName = AppFontName.thin
        case "CTFontEmphasizedUsage":
            fontName = AppFontName.bold
        case "CTFontMediumUsage":
            fontName = AppFontName.bold
        case "CTFontDemiUsage":
            fontName = AppFontName.regular
        case "CTFontObliqueUsage":
            fontName = AppFontName.italic
        default:
            fontName = AppFontName.regular
        }
        //print(Font.fontSize)
        self.init(name: fontName, size: fontDescriptor.pointSize + Font.fontSize)
    }
    
    class func overrideInitialize() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethodWithWeight = class_getClassMethod(self, #selector(systemFont(ofSize: weight:))),
            let mySystemFontMethodWithWeight = class_getClassMethod(self, #selector(mySystemFont(ofSize: weight:))) {
            method_exchangeImplementations(systemFontMethodWithWeight, mySystemFontMethodWithWeight)
        }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
            let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
        
        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
            let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldSystemFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
        
        if let italicSystemFontMethod = class_getClassMethod(self, #selector(italicSystemFont(ofSize:))),
            let myItalicSystemFontMethod = class_getClassMethod(self, #selector(myItalicSystemFont(ofSize:))) {
            method_exchangeImplementations(italicSystemFontMethod, myItalicSystemFontMethod)
        }
        
        if let initCoderMethod = class_getInstanceMethod(self, #selector(UIFontDescriptor.init(coder:))), // Trick to get over the lack of UIFont.init(coder:))
            let myInitCoderMethod = class_getInstanceMethod(self, #selector(UIFont.init(myCoder:))) {
            method_exchangeImplementations(initCoderMethod, myInitCoderMethod)
        }
    }
}
