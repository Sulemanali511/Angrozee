//
//  PhonePickerDelegate.swift
//  CountryPicker
//
//  Created by Suleman Ali on 20/06/2020.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import Foundation
protocol phonePickerDelegate: class {
    func countrySelected(code: String, dial_code: String,Countryname:String,id:Int)
}
