//
//  CustomTabBar.swift
//  agora
//
//  Created by Suleman Ali on 29/05/2021.
//

import UIKit

class CustomTabBar: UITabBar {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        var newReact = rect
        newReact.size.width =  newReact.size.width - 30
        newReact.origin.x = 10
        
        super.draw(newReact)
        // Drawing code
    }


}
