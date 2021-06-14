//
//  BottomCenterButton.swift
//  Sader
//
//  Created by Adnan Majeed on 7/9/18.
//  Copyright © 2018 TimeLine. All rights reserved.
//

import UIKit

class BottomCenterButton: UIView {
    @IBOutlet  weak var btnCentered: UIButton!
    @IBOutlet  weak var btnYearMenu: UIButton!
    
    @IBOutlet  public weak var lblYear: UILabel!
    
    @IBOutlet  weak var colorView: UIView!
    @IBOutlet  weak var buttonCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet  weak var viewSeparatorLine: UIView!
    @IBOutlet  weak var viewCenterMainMenu: UIView!
    @IBOutlet  weak var viewYearMenu: UIView!
    @IBOutlet  public weak var lblStart: UILabel!
    
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
        
        return UINib(nibName: "BottomCenterButton", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    //     func addTarget(target: AnyObject, action: Selector, forControlEvents: UIControlEvents) {
    //        btnCentered.addTarget(target, action: action, for: forControlEvents)
    //    }
    
    
}
