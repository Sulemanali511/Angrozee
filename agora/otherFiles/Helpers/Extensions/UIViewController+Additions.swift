//
//  Extension+UIViewController.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import UIKit

extension UIViewController{
 public  func removeTitle(){
    let currentTab = self.tabBarController?.selectedIndex
    if let tab = self.tabBarController?.tabBar.items  {
        for (index, element) in tab.enumerated() {
            if index == currentTab {
                if index == 0{
                    element.title = "DashBoard"
                }else if index == 1{
                    element.title = "Home"
                }else if index == 2{
                    element.title = "Calculator"
                }else if index == 3{
                    element.title = "Profile"
                }
            }
            else {
                element.title = ""
            }
            
        }
        
    }
 }
        
        
    
    

    
    func navigationbarAppearence(color:UIColor = UIColor(named:"newBackColor") ?? .white){
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = color
            
            navBarAppearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = navBarAppearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }else{
            self.navigationController?.navigationBar.barTintColor = UIColor.groupTableViewBackground
            self.navigationController?.navigationBar.shadowImage = UIImage()
            navigationController?.navigationBar.tintColor = UIColor.groupTableViewBackground
        }
    }
    

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func clearNavigation(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.titleTextAttributes = [.backgroundColor:UIColor.clear,.foregroundColor: UIColor.white,.font: UIFont(name: "DiodrumCyrillic-Regular", size: 20)!]
    }
    
    
    func addNavigationBackButton(Imagenamed:String = "ic_back",tintColor:UIColor = .black){
        let image = UIImage(named:Imagenamed)!.withRenderingMode(.alwaysTemplate)
        let btnCancel = UIBarButtonItem(image: image.imageFlippedForRightToLeftLayoutDirection(), style: .plain, target: self, action: #selector(btnBackAction))
        btnCancel.tintColor = tintColor
        self.navigationItem.leftBarButtonItem  = btnCancel
    }
    @objc func btnBackAction(){
        self.navigationController?.popViewController(animated: true)
    }
}


