//
//  AlertControllerTableView.swift
//  Smart Care
//
//  Created by Suleman Ali on 03/05/2021.
//


import Foundation
import UIKit
import SwiftyJSON
import Nuke
class AlertControllerTableView : UITableViewController
{
    let cellReuseIdentifier = "cell"
    var contentArray:[ConfigData]?
    var onComplete: ((_ result: ConfigData,_ selectedValue:String)->())? //an optional function
    var selectedValue:String?
    
    /**
        When coming form Project creation, to show clients and its members
     */
    //var arrClients = [ClientModel]()
    var arrClients:[ConfigData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let btnCancel = UIBarButtonItem(title: "Cancel".localized, style: .plain, target: self, action: #selector(clickButton))
//        btnCancel.tintColor = UIColor.black
//        self.navigationItem.leftBarButtonItem  = btnCancel

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    //MARK: - Tableview delegate and datasource
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if selectedValue == "clientMember"{
            return 50
        }else{
            return 0
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
      
            return UIView()
        
    }
  /*  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if selectedValue == "clientMember"{
            return arrClients![section].organizationName
        }else{
            return ""
        }
    
    }*/
    override func numberOfSections(in tableView: UITableView) -> Int {
       
            return arrClients.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return arrClients.count
       
     
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 70
       
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath as IndexPath)
        
        let objMember = arrClients[indexPath.section]
        cell.textLabel?.text = objMember.title ?? ""
        let fileUrl = URL(string: objMember.PhotoPath ?? "" )!
        let request =  ImageRequest(url: fileUrl, processors: [
            ImageProcessors.Resize(size: (cell.imageView!.bounds.size))
        ])
        Nuke.loadImage(with: request, into: cell.imageView!)
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
       
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objMember = arrClients[indexPath.row]
        let obj = objMember
        onComplete!(obj,selectedValue!)
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

class ConfigData:NSObject{
    
    var id : String!
    var title : String!
    var PhotoPath : String!
    var Colors : String!
    var Gender : String!
    init (id:String,title:String,PhotoPath:String,Colors:String,Gender : String){
        self.id = id
        self.title = title
        self.PhotoPath = PhotoPath
        self.Colors = Colors
        self.Gender = Gender
    }
    
}



