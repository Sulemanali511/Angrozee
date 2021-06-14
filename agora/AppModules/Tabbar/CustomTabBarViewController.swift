//
//  CustomTabBarViewController.swift
//  agora
//
//  Created by Suleman Ali on 29/05/2021.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    let gradientlayer = CAGradientLayer()
    override func viewDidLoad() {
       
      
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setGradientBackground(colorOne: UIColor(named: "AppSecondryColor")!, colorTwo: UIColor(named:"AppThemeColor")!)
    }
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor)  {
           
        
            DispatchQueue.main.asyncAfter(deadline: .now()+0.001, execute: {
                
                self.tabBar.backgroundColor = UIColor.clear
                self.tabBar.layer.backgroundColor = UIColor.clear.cgColor
                
                self.tabBar.layer.cornerRadius = 10
                self.tabBar.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
                self.tabBar.frame.size.width =  self.tabBar.frame.size.width - 30
               self.gradientlayer.frame = CGRect(x: self.tabBar.frame.minX + 15 , y: 0, width: self.tabBar.frame.width, height: self.tabBar.frame.height)
                self.gradientlayer.cornerRadius = 10
                self.gradientlayer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
                self.gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
                self.gradientlayer.locations = [0, 1]
                self.gradientlayer.startPoint = CGPoint(x: 0.0, y: 0.0)
                self.gradientlayer.endPoint = CGPoint(x: 0.0, y: 1.0)
                self.tabBar.layer.insertSublayer(self.gradientlayer, at: 0)
                
                self.tabBar.clipsToBounds = true
   
        })
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

