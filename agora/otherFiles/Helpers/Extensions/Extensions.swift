//
//  Extensions.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import Foundation
import UIKit
import AVKit
import AVFoundation
import SwiftyJSON
extension String {
    
    func toString(_ anything: Any?) -> String {
        if let any = anything {
            if let num = any as? NSNumber {
                return num.stringValue
            } else if let str = any as? String {
                return str
            }
        }
        return ""
        
    }
    
    var aslink:String{
        if  !self.contains("https://") && !self.contains("http://") && !self.contains("HTTPS://") && !self.contains("HTTP://"){
            return "https://" + self
        }
        return self
    }
    
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        //        formatter.currencySymbol =  "AED"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        //  return toString(number)
        return formatter.string(from: number)!
        
    }
    
    var encodeURL: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func addParams(params: [String]) -> String {
        
        var count = 1
        var newURL = self
        for param in params {
            newURL = newURL.replacingOccurrences(of: "*param\(count)*", with: param.encodeURL)
            count += 1
            
        }
        return newURL
    }
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return nil }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
    
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
    
    // set the max length of the number to display
    public func setMaxLength(of maxLength: Int) -> String {
        var tmp = self
        
        if tmp.count > maxLength {
            var numbers = tmp.map({$0})
            
            if numbers[maxLength - 1] == "." {
                numbers.removeSubrange(maxLength+1..<numbers.endIndex)
            } else {
                numbers.removeSubrange(maxLength..<numbers.endIndex)
            }
            
            tmp = String(numbers)
        }
        return tmp
    }
    
    // remove the '.0' when the number is not decimal
    public func removeAfterPointIfZero() -> String {
        let token = self.components(separatedBy: ".")
        
        if !token.isEmpty && token.count == 2 {
            switch token[1] {
            case "0", "00", "000", "0000", "00000", "000000":
                return token[0]
            default:
                return self
            }
        }
        return self
    }
    
}

extension DateFormatter {
    
    func dateFromMultipleFormats(fromString dateString: String) -> Date? {
        
        //"2020-09-06T08:29:34.9087912+00:00"
        
        let formats: [String] = [
            "d  MMMM,  yyyy",
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss +zzzz",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS +zzzz",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-ddTHH:mm:ssZ",
            "yyyy-MM-dd'T'hh:mm:ssZ",
            "yyyy-MM-ddTHH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS+XXX",
            "yyyy-MM-ddTHH:mm:ss.SSSSSSS+XX:XX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS+XX:XX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS+XXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSXXX",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'hh:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS",
            "yyyy-MM-dd'T'hh:mm:ss.SSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS a",
            "yyyy-MM-dd'T'hh:mm:ss.SSSS a",
            "yyyy-MM-dd'T'hh:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss +zzzz",
            "yyyy-MM-dd'T'hh:mm:ss +zzzz",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS +zzzz",
            "yyyy-MM-dd'T'hh:mm:ss.SSSS +zzzz",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS'Z'",
            "yyyy-MM-dd'T'hh:mm:ss.SSSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'hh:mm:SSZ",
            "yyyy-MM-dd HH:mm:ss",
            "yyyy-MM-dd HH:mm a",
            "yyyy-MM-ddTHH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ss",
            "dd-MMM-yy HH:mm"        ]
        for format in formats {
            self.dateFormat = format
            if let date = self.date(from: dateString) {
                return date
            }
        }
        return nil
    }
    
    static var sharedDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        dateFormatter.timeZone = TimeZone.current//TimeZone(abbreviation: "UTC")
        
        return dateFormatter
    }()
    
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension Date {
    var currentTimeStamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}



extension UIPanGestureRecognizer {
    
    enum GestureDirection {
        case Up
        case Down
        case Left
        case Right
        case NIL
    }
    
    /// Get current vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func verticalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).y > 0 ? .Down : .Up
    }
    
    /// Get current horizontal direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func horizontalDirection(target: UIView) -> GestureDirection {
        return self.velocity(in: target).x > 0 ? .Right : .Left
    }
    
    //    func horizontalDirection(target: UIView) -> GestureDirection {
    //        if self.velocity(in: target).x > 100 {
    //            return .Right
    //        }
    //        else if self.velocity(in: target).x < -100
    //        {
    //            return .Left
    //        }else
    //        {
    //            return .NIL
    //        }
    //        return self.velocity(in: target).x > 200 ? .Left : .Right
    //    }
    
    /// Get a tuple for current horizontal/vertical direction
    ///
    /// - Parameter target: view target
    /// - Returns: current direction
    func versus(target: UIView) -> (horizontal: GestureDirection, vertical: GestureDirection) {
        return (self.horizontalDirection(target: target), self.verticalDirection(target: target))
    }
    
}






extension UIViewController {
    ///present a view controller form presented view controller
    func presentViewControllerFromVisibleViewController(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let navigationController = self as? UINavigationController {
            navigationController.topViewController?.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: flag, completion: completion)
        } else if let tabBarController = self as? UITabBarController {
            tabBarController.selectedViewController?.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: flag, completion: completion)
        } else if let presentedViewController = presentedViewController {
            presentedViewController.presentViewControllerFromVisibleViewController(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            present(viewControllerToPresent, animated: flag, completion: completion)
            
        }
    }
    
    /// The visible view controller from a given view controller
    var myvisibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.myvisibleViewController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.myvisibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.myvisibleViewController
        } else {
            return self
        }
    }
}

extension UIApplication {
    /// The top most view controller
    static var topMostViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.myvisibleViewController
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func relativePast(for date : Date) -> String {
        
        let units = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        if components.year! > 0 {
            return "\(components.year?.asWord?.capitalizingFirstLetter() ?? "") " + (components.year! > 1 ? "years" : "year")
            
        } else if components.month! > 0 {
            return "\(components.month?.asWord?.capitalizingFirstLetter() ?? "") " + (components.month! > 1 ? "months" : "month")
            
        } else if components.weekOfYear! > 0 {
            return "\(components.weekOfYear?.asWord?.capitalizingFirstLetter() ?? "") " + (components.weekOfYear! > 1 ? "weeks" : "week")
            
        } else if (components.day! > 0) {
            let str = "days"
            return (components.day! > 1 ? "\(components.day?.asWord?.capitalizingFirstLetter() ?? "") \(str)" : "Yesterday")
            
        } else if components.hour! > 0 {
            return "\(components.hour?.asWord?.capitalizingFirstLetter() ?? "") " + (components.hour! > 1 ? "hours" : "hour")
            
        } else if components.minute! > 0 {
            return "\(components.minute?.asWord?.capitalizingFirstLetter() ?? "") " + (components.minute! > 1 ? "minutes" : "minute")
            
        } else {
            return  (components.second! > 1 ? "\(components.second?.asWord?.capitalizingFirstLetter() ?? "") " + "seconds" : "Just now")
        }
    }
}

extension UIDevice {
    var iPhoneX: Bool { UIScreen.main.nativeBounds.height == 2436 }
    var iPhone: Bool { UIDevice.current.userInterfaceIdiom == .phone }
    var iPad: Bool { UIDevice().userInterfaceIdiom == .pad }
    enum ScreenType: String {
        case iPhones_4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhones_X_XS = "iPhone X or iPhone XS"
        case iPhone_XR_11 = "iPhone XR or iPhone 11"
        case iPhone_XSMax_ProMax = "iPhone XS Max or iPhone Pro Max"
        case iPhone_11Pro = "iPhone 11 Pro"
        case iPhone_12ProMax = "iPhone 12 Pro Max"
        
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhone_XR_11
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2426:
            return .iPhone_11Pro
        case 2436:
            return .iPhones_X_XS
        case 2688:
            return .iPhone_XSMax_ProMax
        case 2778:
            return .iPhone_12ProMax
        default:
            return .unknown
        }
    }
    
}


extension UIAlertController {
    static func actionSheetWithItems<A : Equatable>(items : [(title : String, value : A)], currentSelection : A? = nil, action : @escaping (A) -> Void) -> UIAlertController {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for (var title, value) in items {
            if let selection = currentSelection, value == selection {
                // Note that checkmark and space have a neutral text flow direction so this is correct for RTL
                title = "✔︎ " + title
            }
            controller.addAction(
                UIAlertAction(title: title, style: .default) {_ in
                    action(value)
                }
            )
        }
        return controller
    }
}


extension Collection where Iterator.Element == [String:Any] {
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let arr = self as? [[String:Any]],
           let dat = try? JSONSerialization.data(withJSONObject: arr, options: options),
           let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
    
    
}


extension Collection {
    func toJSONValue() -> JSON {
        return JSON(self)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}


extension AVAsset {
    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
extension UIImageView{
    open override func awakeFromNib() {
        super.awakeFromNib()
        if Language.language == Language.arabic{
            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else{
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}

extension UICollectionView{
    open override func awakeFromNib() {
        super.awakeFromNib()
        if Language.language == Language.arabic{
            self.contentMode = .right
            self.semanticContentAttribute = .forceRightToLeft
            //            self.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        else{
            self.contentMode = .left
            self.semanticContentAttribute = .forceLeftToRight
            //            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
//extension UICollectionViewCell{
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        if Language.language == Language.arabic{
//            self.contentView.transform = CGAffineTransform(scaleX: -1, y: 1)
//        }
//        else{
//            self.contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
//        }
//    }
//}
public extension Int {
    var asWord: String? {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
extension TimeInterval {
    func timeString() -> String {
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self)
            % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

extension NSLocale {
    func extensionCode(countryCode : String?) -> String? {
        let prefixCodes = ["AC" : "247", "AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263", "AQ" : "672", "AX" : "358", "BQ" : "599", "BV": "55"]
        
        let countryDialingCode = prefixCodes[countryCode ?? "PK"] ?? nil
        return countryDialingCode
    }
}

func getflag(country:String) -> String {
    let base = 127397
    var usv = String.UnicodeScalarView()
    for i in country.utf16 {
        usv.append(UnicodeScalar(base + Int(i))!)
    }
    return String(usv)
}


