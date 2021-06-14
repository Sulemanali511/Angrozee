//
//  NoDataView.swift
//  PMS
//
//  Created by Adnan Majeed on 4/30/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    @IBOutlet public var placeHolderImage: UIImageView! 
    @IBOutlet public var lblMessage: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "NoDataView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

//    override init(frame: CGRect) {
//        super.init(frame: frame)
////        self.addCustomView()
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

}
class NotificationBadgeView: UIView {
    @IBOutlet public var placeHolderImage: UIButton!
    @IBOutlet public var lblCount: UILabel!

    class func returnBadgeView(withValue value:Int) -> NotificationBadgeView?{
        
        let xib = UINib(nibName: "NotificationBadgeView", bundle: nil)
        let rawView = xib.instantiate(withOwner: nil, options: nil).first
        if let view = rawView as? NotificationBadgeView{
            view.lblCount.text = String(value)
            return view
        }else{
            return nil
        }
    }
}


class SubjectFooterView: UIView {
    @IBOutlet public var txtSubject: UITextField!
    @IBOutlet public var btnDone: UIButton!
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SubjectFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

}
