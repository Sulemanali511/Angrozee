//
//  CustomCellTableViewCell.swift
//  CountryPicker
//
//  Created by Suleman Ali on 20/06/2020.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var flag: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    var isNationality:Bool = false
    var isFalges:Bool = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
}

var objCountry:Countries?{
    didSet{
        countryName.text = objCountry?.name
        if !isNationality {
        countryCode.text = objCountry?.dial_code
        }
        else
        { countryCode.text = "" }
        if !isFalges{
            flag.text = flag(country: objCountry?.code ?? "")
        }
        else {
            flag.text = ""
        }
        //            flagImage.image = flag(country: objCountry?.code ?? "").image()
        
    }
}


func flag(country:String) -> String {
    let base = 127397
    var usv = String.UnicodeScalarView()
    for i in country.utf16 {
        usv.append(UnicodeScalar(base + Int(i))!)
    }
    return String(usv)
}
}
