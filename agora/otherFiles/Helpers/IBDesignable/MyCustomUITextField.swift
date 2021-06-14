//
//  MyCustomUITextField.swift
//  Recta
//
//  Created by Adnan Majeed on 4/26/20.
//  Copyright © 2020 Adnan Majeed. All rights reserved.
//

import Foundation
import UIKit
import JVFloatLabeledTextField

@IBDesignable
class MyCustomUITextField: JVFloatLabeledTextField {
    @IBInspectable var localizePlaceholder: String = ""{
        didSet {
            self.placeholder = localizePlaceholder.localized
            if Language.language == .arabic{
                self.textAlignment = .right
            }else{
                self.textAlignment = .left
            }
        }
    }
    
}

@IBDesignable
class MyCustomUITextView: JVFloatLabeledTextView {
    @IBInspectable var localizePlaceholder: String = ""{
        didSet {
            self.placeholder = localizePlaceholder.localized
            if Language.language == .arabic{
                self.textAlignment = .right
            }else{
                self.textAlignment = .left
            }
        }
    }
    
}






