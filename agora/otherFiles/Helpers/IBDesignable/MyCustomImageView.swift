//
//  MyCustomImageView.swift
//  Recta
//
//  Created by Adnan Majeed on 4/26/20.
//  Copyright © 2020 Adnan Majeed. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class MyCustomImageView:UIImageView {
    

    @IBInspectable var CustomborderColor:UIColor = UIColor.white {
        willSet {
            layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var  ImageborderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = ImageborderWidth
        }
    }

    @IBInspectable var CustomCornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = CustomCornerRadius
            layer.masksToBounds = true
            layer.borderWidth = 1
            layer.borderColor = CustomborderColor.cgColor

        }
    }
    //
    @IBInspectable var transformImage: Bool = false {
        didSet {
            if Language.language == Language.arabic{
                self.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
        }
    }

    @IBInspectable var roundImage: Bool = false {
        didSet {
            layer.cornerRadius = frame.height/2
            layer.masksToBounds = true
            layer.borderWidth = 1
            layer.borderColor = CustomborderColor.cgColor
        }
    }

 /*   override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
    }*/
}
