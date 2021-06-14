//
//  AppManager.swift
//  Smart Care
//
//  Created by Suleman Ali on 20/05/2021.
//

import Foundation
import JWTDecode
import SwiftyJSON

class AppManager {
    static var shared:AppManager = AppManager()

    var Nationalities:[Countries] = []
    private init(){
        
       
        
    }
    func fetchCountries(){
        ApiManager.getRequest(with: APPURL.GetAllNationalities, parameters: nil, completion: {
            results in
            switch(results) {
            case .success(let result):
                if result["statusCode"].intValue == errorCode.success{
                    for item in result["data"].arrayValue {
                        self.Nationalities.append(Countries(name: item["name"].stringValue, dial_code: item["code"].stringValue, code: item["id"].stringValue))
                    }
                    
                }else{
                    Functions.showToast(message: result["returnMessage"][0].stringValue, type: .failure, duration: 3.0, position: .center)
                }
                
                
                break
            case .failure(let error):
                print(error)
                break
            }
            
            
        })
    }
}

