//
//  MyCustomUILabel.swift
//  Recta
//
//  Created by Adnan Majeed on 4/26/20.
//  Copyright © 2020 Adnan Majeed. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class MyCustomUILabel: UILabel {
    
    
    @IBInspectable var localizeText: String = ""{
        didSet {
            self.text = localizeText.localized
        }
        
    }
    
}

