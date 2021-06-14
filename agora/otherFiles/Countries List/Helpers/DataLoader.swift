//
//  DataLoader.swift
//  CountryPicker
//
//  Created by Suleman Ali on 20/06/2020.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import Foundation
public class DataLoader {
    
    var countriesArray = [Countries]()
    
    init() {
        load()
        sort()
    }

    func load() {
        
        if let fileLocation = Bundle.main.url(forResource: "countireslist", withExtension: "json") {
            
            do {
                let data = try Data(contentsOf: fileLocation)
               
                let jsonDecoder = JSONDecoder()
                let dataFromJson = try jsonDecoder.decode([Countries].self, from: data)
            
                self.countriesArray = dataFromJson
            }
            catch {
                print(error)
            }
        }
    }
    
    func sort() {
        self.countriesArray = self.countriesArray.sorted(by: { $0.name < $1.name })
    }
}
