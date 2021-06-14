//
//  DashboardViewController.swift
//  agora
//
//  Created by Suleman Ali on 14/06/2021.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.title = "Dashboard"
        removeTitle()
    }



}
