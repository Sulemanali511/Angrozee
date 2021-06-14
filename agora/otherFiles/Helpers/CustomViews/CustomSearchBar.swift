//
//  CustomSearchBar.swift
//  Recta
//
//  Created by Adnan Majeed on 4/9/20.
//  Copyright © 2020 Adnan Majeed. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CustomSearchBarDelegate {
    @objc optional func textDidChange(searchText:String)
    @objc optional func textFieldShouldReturn(searchText:String)
}

class CustomSearchBar: UIView , UITextFieldDelegate {
    
    var delegate:CustomSearchBarDelegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var innerView: UIView!


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomSearchBar", owner: self, options: nil)
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        contentView.frame = self.bounds
        txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for:.editingChanged)

    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText  = textField.text!
        delegate?.textDidChange!(searchText: searchText)
        if searchText.isEmpty == true {
            self.iconImg.image = UIImage(named: "ic_search")
        }else{
            self.iconImg.image = UIImage(named: "ic_closeCross")
        }
    }

    @IBAction func btnClearAction(_ sender:UIButton){
        self.txtSearch.text = ""
        self.iconImg.image = UIImage(named: "ic_search")
        delegate?.textDidChange!(searchText: "")

    }
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchText  = textField.text!
        print(searchText)
//        delegate?.textFieldShouldReturn!(searchText: searchText)
        delegate?.textFieldShouldReturn?(searchText: searchText)
       textField.resignFirstResponder()
       return true
    }

}
