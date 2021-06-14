//
//  Functions.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import Foundation
import UIKit
import SwiftMessages
import Toast_Swift
import SVProgressHUD
import SwiftyJSON
import AudioToolbox
import AVFoundation
import SafariServices


enum ToastType {
    case success
    case failure
    case warning
}

class Functions: NSObject {
    
    static func chechPhone(inputNumber:String)->Bool{
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: inputNumber, options: [], range: NSMakeRange(0, inputNumber.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == inputNumber.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
   
    
    
    class func openLink(url:String,controller:UIViewController){
        if url.count <= 5 {
            Functions.showToast(message: "Link Not Valid")
            return
        }
        guard let requestUrl = URL(string: url.aslink) else {
            return
        }
        let safariVC = SFSafariViewController(url: requestUrl)
        controller.present(safariVC, animated: true, completion: nil)
        
    }
    class func saveJSON(json: JSON, key:String){
        if let jsonString = json.rawString() {
            UserDefaults.standard.setValue(jsonString, forKey: key)
        }
    }
    
    class func getJSON(_ key: String)-> JSON? {
        var p = ""
        if let result = UserDefaults.standard.string(forKey: key) {
            p = result
        }
        if p != "" {
            if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                do {
                    return try JSON(data: json)
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    static func whereIsMySQLite() {
        let path = FileManager
            .default
            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .last?
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print(path ?? "Not found")
    }
    
    static func calculateDays(startDate:Date = Date(), endDate:Date) -> Int?{
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate)
        let date2 = calendar.startOfDay(for: endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day
    }
    static func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    static func setViewHideShow(view: UIView, hidden: Bool) {
        
        
        view.isHidden = hidden
        
        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
        
        //        UIView.transition(with: view, duration: 0.4, options: .transitionCrossDissolve, animations: {
        //            view.alpha = 0.1
        //
        //        }) { _ in
        //            view.alpha = 1.0
        //        }
    }
    
    
    static func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    
    static func moveToController(identifier:String ,controller:UIViewController , storyboard:String = "CreateActions"){
        
        let storyboard = UIStoryboard.init(name: storyboard, bundle: Bundle.main)
        let resultController = storyboard.instantiateViewController(withIdentifier: identifier)
        let navController = UINavigationController.init(rootViewController: resultController)
        navController.navigationBar.prefersLargeTitles = true
        
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        navController.modalPresentationStyle = .fullScreen
        controller.present(navController, animated: true, completion: nil)
        
    }
    
    static func showToast(message:String,type:ToastType = .warning,duration:Double = 2.0 ,position:ToastPosition = .center){
        
        var style = ToastStyle()
        // this is just one of many style options
        //style.messageColor = .blue
        
        if type == .success{
            style.backgroundColor = UIColor(named: "GreenColour") ?? .green
        }else if type == .failure{
            style.backgroundColor = .systemRed
        }else if type == .warning{
            style.backgroundColor = .systemBlue
            
        }
        //ToastManager.shared.style = style
        
        
        let window = UIApplication.shared.keyWindow!
        window.hideAllToasts()
        
        // window.makeToast(message, duration: duration, position: position)
        
        window.makeToast(message, duration: duration, position: position, title: nil, image: nil, style: style) { (didTap) in
            if didTap {
                window.hideAllToasts()
            } else {
                print("completion without tap")
            }
            
        }
        //        window.makeToast("This is a piece of toast", duration: 2.0, point: CGPoint(x: 110.0, y: 110.0), title: "Toast Title", image: UIImage(named: "toast.png")) { didTap in
        //            if didTap {
        //                print("completion from tap")
        //            } else {
        //                print("completion without tap")
        //            }
        //        }
        
    }
    static func showActivity(progres:Double = 0.0){
        if progres == 0.0{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
            
        }else{
            let value = progres*100
            SVProgressHUD.showProgress(Float(progres), status: String(format: "%.1f percent", value))
            SVProgressHUD.setBackgroundColor(.lightGray)
        }
    }
    
    static func hideActivity(){
        SVProgressHUD.dismiss()
    }
    static func deleteAlert(message:String = "Are you sure you want to delete?",controller:UIViewController, completion: @escaping()->()){
        let alert = UIAlertController(title: "".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { action in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { action in
            completion()
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    static func ArchiveAlert(message:String = "Are you sure you want to Archive?",controller:UIViewController, completion: @escaping()->()){
        let alert = UIAlertController(title: "".localized, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: { action in
            print("cancel")
        }))
        alert.addAction(UIAlertAction(title: "Yes".localized, style: .destructive, handler: { action in
            completion()
        }))
        controller.present(alert, animated: true, completion: nil)
    }
    static func noInternetConnection(status:Bool){
        
        if status == true{
            SwiftMessages.hideAll()
            SwiftMessages.pauseBetweenMessages = 0.0
            
            let view: MessageView
            view = try! SwiftMessages.viewFromNib()
            
            view.configureContent(title: "", body: "Please check your internet connection".localized, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "", buttonTapHandler: { _ in
                
                SwiftMessages.hide()
                
            })
            view.accessibilityPrefix = "error"
            view.configureDropShadow()
            view.button?.isHidden = true
            
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            config.presentationContext = .window(windowLevel: .statusBar)
            config.preferredStatusBarStyle = .lightContent
            config.interactiveHide = false
            config.duration = .forever
            view.configureTheme(backgroundColor: UIColor.red, foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
            
            config.dimMode = .gray(interactive: true)
            SwiftMessages.show(config: config, view: view)
            
        }else{
            SwiftMessages.hide()
            SwiftMessages.hideAll()
            SwiftMessages.pauseBetweenMessages = 0.0
        }
        
    }
    
    
    static func ChangeDateFormateReturnString( dateString : String ,formate : String) -> String {
        
        // print(dateString)
        if dateString != ""{
            let strDate = dateString
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let date = dateFormatter.dateFromMultipleFormats(fromString: strDate)
            
            dateFormatter.dateFormat = formate
            
            let myStringafd = dateFormatter.string(from: date ?? Date())
            
            return myStringafd
        }else{
            return ""
        }
        
    }
    
    
    static func ChangeDateFormateReturnDate( dateString : String ,formate : String) -> Date {
        
        let strDate = dateString
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = NSTimeZone() as TimeZone?
        let date = dateFormatter.dateFromMultipleFormats(fromString: strDate)
        if date == nil{
            return Date()
        }else{
            return date! as Date
        }
        
    }
    static func ChangeDateFormateReturnDate( dateString : Date ,formate : String) -> Date {
        
       
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = NSTimeZone() as TimeZone?
        let datestr = dateFormatter.string(from: dateString)
        let date = dateFormatter.date(from: datestr)
        if date == nil{
            return Date()
        }else{
            return date! as Date
        }
        
    }
    static func ChangeDateFormateReturnString( dateString : Date ,formate : String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let myString = formatter.string(from: dateString) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = formate
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    ///format of Date is 1st,2nd,3rd 4th -august 2020
    static func ChangeDateFormateReturnStringWithNthFormat( dateString : Date ,formate : String) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let myString = formatter.string(from: dateString) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = formate
        let myStringafd = formatter.string(from: yourDate!)
        
        return myStringafd
    }
    
   
    
    static func createNoDataView(view:UIView,imageName:String,text:String){
        
        
        
        if let background = view.viewWithTag(12322222){
            
            background.removeFromSuperview()
            
        }
        
        let nodataView = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.first as! NoDataView
        
        
        
        //        nodataView.frame = self.tblProjectList.frame
        
        nodataView.frame = view.bounds
        
        //nodataView.placeHolderImage.loadGif(name: "source")
        
        nodataView.placeHolderImage.image = UIImage(named: imageName)
        
        nodataView.tag = 12322222
        
        
        
        nodataView.lblMessage.text = text.localized
        
        view.addSubview(nodataView)
        
        //view.bringSubviewToFront(nodataView)
        
        
        
    }
    
    static func removeNoDataview(view:UIView){
        if let background = view.viewWithTag(12322222){
            
            background.removeFromSuperview()
            
        }
//        let nodataView = Bundle.main.loadNibNamed("NoDataView", owner: self, options: nil)?.first as! NoDataView
//        nodataView.frame = view.bounds
//        nodataView.tag = 12322222
//        view.willRemoveSubview(nodataView)
    }
    static func showSimpleAlert(message:String) {
        let alert = UIAlertController(title: "Warning", message: message,         preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
        }))
        
        UIApplication.topMostViewController?.present(alert, animated: true, completion: nil)
    }
    
    static func getCurrentTimeInString(date:Date,formate:String) -> String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        let date = date
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    
    static func checkfileInDocumentDirecotory(with fileUrl:String) -> String{
        if fileUrl != "no url"{
            let newStr = fileUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? fileUrl
            print(newStr)
            let fileUrlnew = URL(string: newStr)
            //let trimmedString = string.trimmingCharacters(in: .whitespaces)
            
            print(fileUrlnew?.lastPathComponent)
            let fileName = String(fileUrlnew?.lastPathComponent ?? "")
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let url = NSURL(fileURLWithPath: path)
            if let pathComponent = url.appendingPathComponent(fileName as String) {
                let filePath = pathComponent.path
                let fileManager = FileManager.default
                if fileManager.fileExists(atPath: filePath) {
                    print("FILE AVAILABLE")
                    return filePath
                } else {
                    print("FILE NOT AVAILABLE")
                    return ""
                    
                }
            } else {
                print("FILE PATH NOT AVAILABLE")
                return ""
            }
        }else{
            return fileUrl
        }
        
    }
    
    static func getAudioDuration(path:URL) -> String{
        
        let duration = AVURLAsset(url: path).duration.seconds
        
        let time: String
        if duration > 3600 {
            time = String(format:"%02i:%02i:%02i",
                          Int(duration/3600),
                          Int((duration/60).truncatingRemainder(dividingBy: 60)),
                          Int(duration.truncatingRemainder(dividingBy: 60)))
        } else {
            //   return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
            
            time = String(format:"%02i:%02i",
                          Int((duration/60).truncatingRemainder(dividingBy: 60)),
                          Int(duration.truncatingRemainder(dividingBy: 60)))
        }
        return time
        //        let audioAsset = AVURLAsset.init(url: path, options: nil)
        //        let duration = audioAsset.duration
        //        let durationInSeconds = CMTimeGetSeconds(duration)
        //        return String(durationInSeconds)
    }
    
    static func showMessageBanner(with json : JSON)
    {
        AudioServicesPlaySystemSound(SystemSoundID(1007))
        SwiftMessages.hideAll()
        SwiftMessages.pauseBetweenMessages = 0.0
        
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: json["senderName"].stringValue, body: json["message"].stringValue, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureTheme(backgroundColor: UIColor.darkGray, foregroundColor: UIColor.white, iconImage: nil, iconText: nil)
        view.button?.isHidden = true
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: .normal)
        config.preferredStatusBarStyle = .lightContent
        config.interactiveHide = true
        SwiftMessages.show(config: config, view: view)
        
        view.tapHandler = { _ in
            SwiftMessages.hide()
            //Functions.moveToViewController(json: json)
        }
        
    }
    
    
    static func getFileSize(url: URL) -> String {
        do {
            let resources = try url.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            //print ("\(fileSize)")
            let kb = Double(fileSize)/1024.0
            //print(String(format: "%.1f", kb))
            let mb = kb/1024.0
            // print(String(format: "%.1f", mb))
            
            if kb <= 1024.0{
                return (String(format: "%.f KB", kb))
            }else if mb <= 1024.0{
                return (String(format: "%.1f MB", mb))
            }
            
        } catch {
            print("Error: \(error)")
        }
        return ""
        
    }
    
    
    static func makeCall(phoneNumber:String){
        
        var phoneNumber = phoneNumber
        
        if phoneNumber != ""{
            
            phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
            phoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
            
            print(phoneNumber)
            if let url = URL(string: "tel://\(String(format: "%@", phoneNumber ))"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }else{
                Functions.showToast(message: "Invalid phone number \n \(phoneNumber)".localized, duration: 2.0)
            }
            
        }else{
            Functions.showToast(message: "No phone number found!".localized, duration: 2.0)
        }
        
    }
    
    
    
    /**
     https://stackoverflow.com/questions/2509443/check-if-uicolor-is-dark-or-bright
     */
    static func checkColorBrightness(hexString:String) -> Int{
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        let test = ((r * 299) + (g * 587) + (b * 114)) / 1000
        return Int(test)
        //  self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        
    }
    static func daysBetweenDatesReturnString(startDate: Date, endDate: Date) -> String
    {
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: startDate )
        let date2 = calendar.startOfDay(for: endDate )
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        let days = components.day ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        guard let first = formatter.string(from: NSNumber(value: days)) else { return "" }
        
        return first
    }
    ///change the format to 24th aughust 2020
    static func ChsngeTheFormatToString(startDate:Date = Date(),format:String = "MMMM yyyy") -> String
    {
        //        let startDate = Functions.ChangeDateFormateReturnDate(dateString: DateString, formate: "MM-dd-yyyy")
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: startDate )
        let components = date1.get(.day, .month, .year)
        let day = components.day ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        guard let first = formatter.string(from: NSNumber(value: day)) else { return "" }
        let finalDate = first + " " + Functions.ChangeDateFormateReturnString(dateString: date1, formate: "MMMM yyyy")
        
        return finalDate
    }
    
    
  
    
   
}
extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
}
struct Constants {
    static let NHInfoConnectionString = "NotificationHubConnectionString";
    static let NHInfoHubName = "NotificationHubName";
    static let NHUserDefaultTags = "notification_tags";
}



func showAlert(_ message: String, withTitle title: String = "Alert") {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
}
