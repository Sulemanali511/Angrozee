//
//  ViewController.swift
//  CountryPicker
//
//  Created by Suleman Ali on 20/06/2020.
//  Copyright © 2020 Suleman Ali. All rights reserved.
//

import UIKit
class CountriesViewController: UIViewController{

    weak var delegate : phonePickerDelegate?
    var Countries:[Countries]!
    var searchCountry:[Countries]!
    @IBOutlet weak var countriesTableView: UITableView!
    var isNationality:Bool = false
    var searching = false
    var isFalges:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesTableView.register(UINib(nibName: "CustomCellTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        if Countries == nil {
            Countries = DataLoader().countriesArray
            searchCountry = DataLoader().countriesArray
        }
        
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension CountriesViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  Countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = countriesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCellTableViewCell
        cell.isFalges = isFalges
        cell.isNationality = isNationality
        cell.objCountry =  Countries[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.delegate?.countrySelected(code: Countries[indexPath.row].code, dial_code: Countries[indexPath.row].dial_code,Countryname:Countries[indexPath.row].name,id:indexPath.row)
        self.dismiss(animated: true, completion: nil)
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
extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    ///From Other Languages to English Int Number
    func toIntString() -> String {
        let numberFormat = NumberFormatter()
        numberFormat.locale = Locale(identifier: "EN")
        if let getOP = numberFormat.number(from: self){
            return getOP.stringValue
        }
        else {
            return "0"
        }
    }
    
}
extension CountriesViewController :UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            Countries =  searchCountry
        }else{
            Countries =  searchCountry
            Countries = Countries.filter({($0.name.localizedCaseInsensitiveContains(searchText)) || ($0.dial_code.localizedCaseInsensitiveContains(searchText)) })
        }
        countriesTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Countries =  searchCountry
        countriesTableView.reloadData()
        searchBar.text = nil
        searchBar.endEditing(true)
    }
}
