//
//  HomeViewController.swift
//  agora
//
//  Created by Suleman Ali on 14/06/2021.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.title = "Home"
        removeTitle()
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
