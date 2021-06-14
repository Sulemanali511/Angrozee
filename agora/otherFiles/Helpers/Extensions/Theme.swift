//
//  Theme.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import Foundation
import UIKit


// reference from given link
//https://medium.com/ios-os-x-development/a-smart-way-to-manage-colours-schemes-for-ios-applications-development-923ef976be55

// Usage Examples
//let shadowColor = Color.shadow.value
//let shadowColorWithAlpha = Color.shadow.withAlpha(0.5)
let customColorWithAlpha = Color.custom(hexString: "#123edd", alpha: 1).value

enum Color {
    
    
    case custom(hexString: String, alpha: Double)
    
}

extension Color {
    
    var value: UIColor {
        var instanceColor = UIColor.clear
        
        switch self {
        case .custom(let hexValue, let opacity):
            instanceColor = UIColor(hexString: hexValue).withAlphaComponent(CGFloat(opacity))
        }
        return instanceColor
    }
}
