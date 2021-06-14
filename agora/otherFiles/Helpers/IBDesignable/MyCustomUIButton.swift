//
//  MyCustomUIButton.swift
//  Recta
//
//  Created by Adnan Majeed on 4/26/20.
//  Copyright © 2020 Adnan Majeed. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class MyCustomUIButton: UIButton {
    
    @IBInspectable var CustomBorderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = CustomBorderColor.cgColor
        }
    }
    
    @IBInspectable var CustomBorderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = CustomBorderWidth
        }
    }
    
    @IBInspectable var CustomCornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = CustomCornerRadius
        }
    }

    @IBInspectable var localizeText: String = ""{
        didSet {
            //self.titleLabel?.text = localizeText.localized
            self.setTitle(localizeText.localized, for: .normal)
        }
        
    }
}
