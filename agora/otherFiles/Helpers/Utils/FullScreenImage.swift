//
//  FullScreenImage.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import Foundation
import UIKit

class FullScreenImage: UIImageView {
    
    init(image:UIImage) {
        
        super.init(image: image)
        //super.init(frame: UIScreen.main.bounds)
        //let newImageView = UIImageView(image: image)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = .black
        self.image = image

        self.contentMode = .scaleAspectFit
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage(_:)))
        self.addGestureRecognizer(tap)
        //self.view.addSubview(newImageView)
        
       // UIApplication.shared.keyWindow?.addSubview(newImageView)
        
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.3) {
            
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.3, animations: {
            let imageView = sender.view as! UIImageView
            imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }, completion: {
            (value: Bool) in
          sender.view?.removeFromSuperview()

            self.removeFromSuperview()
        })
        
        //        self.navigationController?.isNavigationBarHidden = false
        //        self.tabBarController?.tabBar.isHidden = false
    }


}


